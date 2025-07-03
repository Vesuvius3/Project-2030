//
//  DayView.swift
//  PRJ-2030
//
//  Created by Hammad Rashid on 7/1/25.
//

import SwiftUI

struct DayView: View {
    @Binding var document: PRJ_2030Document
    @State private var currentDate = Date()
    
    private let calendar = Calendar.current
    private let hourHeight: CGFloat = 60
    private let timeSlots = Array(0...23)
    
    var body: some View {
        VStack(spacing: 0) {
            // Day navigation
            HStack {
                Button(action: previousDay) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text(dayString)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: nextDay) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            // Day view content
            ScrollView {
                HStack(spacing: 0) {
                    // Time column
                    VStack(spacing: 0) {
                        ForEach(timeSlots, id: \.self) { hour in
                            Text(timeString(for: hour))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 60, height: hourHeight, alignment: .topLeading)
                                .padding(.top, 4)
                        }
                    }
                    .background(Color(NSColor.controlBackgroundColor))
                    
                    // Events column
                    GeometryReader { geometry in
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
                            ForEach(eventsForCurrentDate, id: \.id) { event in
                                DayEventBlock(
                                    event: event, 
                                    hourHeight: hourHeight, 
                                    document: $document,
                                    availableWidth: geometry.size.width
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(NSColor.controlBackgroundColor))
                }
            }
        }
    }
    
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: currentDate)
    }
    
    private var eventsForCurrentDate: [CalendarEvent] {
        return document.events.filter { event in
            calendar.isDate(event.startDate, inSameDayAs: currentDate)
        }.sorted { $0.startDate < $1.startDate }
    }
    
    private func timeString(for hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
        return formatter.string(from: date)
    }
    
    private func previousDay() {
        if let newDate = calendar.date(byAdding: .day, value: -1, to: currentDate) {
            currentDate = newDate
        }
    }
    
    private func nextDay() {
        if let newDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
            currentDate = newDate
        }
    }
}

struct DayEventBlock: View {
    let event: CalendarEvent
    let hourHeight: CGFloat
    @Binding var document: PRJ_2030Document
    let availableWidth: CGFloat
    @State private var showingEventDetail = false
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: { showingEventDetail = true }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                if let location = event.location {
                    HStack {
                        Image(systemName: "location")
                            .font(.caption2)
                        Text(location)
                            .font(.caption2)
                    }
                    .foregroundColor(.white.opacity(0.8))
                }
                
                if !event.isAllDay {
                    Text(timeString)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(8)
            .frame(width: availableWidth * 0.9, height: height, alignment: .leading)
            .background(event.color.color)
            .cornerRadius(6)
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
            return 40
        }
        
        let duration = event.endDate.timeIntervalSince(event.startDate)
        let hours = duration / 3600
        return max(30, CGFloat(hours) * hourHeight)
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: event.startDate)) - \(formatter.string(from: event.endDate))"
    }
}

#Preview {
    DayView(document: .constant(PRJ_2030Document()))
} 