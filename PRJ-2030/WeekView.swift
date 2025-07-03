//
//  WeekView.swift
//  PRJ-2030
//
//  Created by Hammad Rashid on 7/1/25.
//

import SwiftUI

struct WeekView: View {
    @Binding var document: PRJ_2030Document
    @State private var currentWeek = Date()
    
    private let calendar = Calendar.current
    private let hourHeight: CGFloat = 60
    private let timeSlots = Array(0...23)
    
    var body: some View {
        VStack(spacing: 0) {
            // Week navigation
            HStack {
                Button(action: previousWeek) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text(weekString)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: nextWeek) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            // Week view content
            ScrollView([.horizontal, .vertical]) {
                HStack(spacing: 0) {
                    // Time column
                    VStack(spacing: 0) {
                        // Header spacer
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 40)
                        
                        // Time slots
                        ForEach(timeSlots, id: \.self) { hour in
                            Text(timeString(for: hour))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 50, height: hourHeight, alignment: .topLeading)
                                .padding(.top, 4)
                        }
                    }
                    .background(Color(NSColor.controlBackgroundColor))
                    
                    // Days columns
                    ForEach(weekDays, id: \.self) { date in
                        GeometryReader { geometry in
                            DayColumn(
                                date: date,
                                isSelected: calendar.isDate(date, inSameDayAs: document.selectedDate),
                                events: eventsForDate(date),
                                hourHeight: hourHeight,
                                document: $document,
                                availableWidth: geometry.size.width
                            ) {
                                document.selectedDate = date
                            }
                        }
                        .frame(width: 120)
                    }
                }
            }
        }
    }
    
    private var weekString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let startOfWeek = weekDays.first ?? currentWeek
        let endOfWeek = weekDays.last ?? currentWeek
        
        if calendar.isDate(startOfWeek, equalTo: endOfWeek, toGranularity: .month) {
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: startOfWeek)
        } else {
            return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
        }
    }
    
    private var weekDays: [Date] {
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: currentWeek)?.start ?? currentWeek
        var days: [Date] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func timeString(for hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
        return formatter.string(from: date)
    }
    
    private func eventsForDate(_ date: Date) -> [CalendarEvent] {
        return document.events.filter { event in
            calendar.isDate(event.startDate, inSameDayAs: date)
        }.sorted { $0.startDate < $1.startDate }
    }
    
    private func previousWeek() {
        if let newDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeek) {
            currentWeek = newDate
        }
    }
    
    private func nextWeek() {
        if let newDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeek) {
            currentWeek = newDate
        }
    }
}

struct DayColumn: View {
    let date: Date
    let isSelected: Bool
    let events: [CalendarEvent]
    let hourHeight: CGFloat
    @Binding var document: PRJ_2030Document
    let availableWidth: CGFloat
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 0) {
            // Day header
            Button(action: onTap) {
                VStack(spacing: 4) {
                    Text(dayOfWeekString)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text("\(calendar.component(.day, from: date))")
                        .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                        .foregroundColor(isSelected ? .white : .primary)
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.accentColor : Color.clear)
                .cornerRadius(6)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Time grid
            ZStack(alignment: .topLeading) {
                // Grid lines
                VStack(spacing: 0) {
                    ForEach(0..<24, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: hourHeight - 1)
                    }
                }
                
                // Events
                ForEach(events, id: \.id) { event in
                    EventBlock(
                        event: event, 
                        hourHeight: hourHeight, 
                        document: $document,
                        availableWidth: availableWidth
                    )
                }
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
        .overlay(
            Rectangle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
        )
    }
    
    private var dayOfWeekString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

struct EventBlock: View {
    let event: CalendarEvent
    let hourHeight: CGFloat
    @Binding var document: PRJ_2030Document
    let availableWidth: CGFloat
    @State private var showingEventDetail = false
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: { showingEventDetail = true }) {
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                if let location = event.location {
                    Text(location)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(1)
                }
                
                if !event.isAllDay {
                    Text(timeString)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(4)
            .frame(width: availableWidth * 0.9, height: height, alignment: .leading)
            .background(event.color.color)
            .cornerRadius(4)
            .offset(x: availableWidth * 0.05, y: yPosition)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingEventDetail) {
            EventDetailView(event: event, document: $document)
        }
    }
    
    private var yPosition: CGFloat {
        if event.isAllDay {
            return 10
        }
        
        let hour = calendar.component(.hour, from: event.startDate)
        let minute = calendar.component(.minute, from: event.startDate)
        return CGFloat(hour) * hourHeight + CGFloat(minute) / 60.0 * hourHeight
    }
    
    private var height: CGFloat {
        if event.isAllDay {
            return 30
        }
        
        let duration = event.endDate.timeIntervalSince(event.startDate)
        let hours = duration / 3600
        return max(20, CGFloat(hours) * hourHeight)
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: event.startDate)
    }
}

#Preview {
    WeekView(document: .constant(PRJ_2030Document()))
} 