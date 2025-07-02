//
//  ContentView.swift
//  PRJ-2030
//
//  Created by Hammad Rashid on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: PRJ_2030Document
    @State private var showingAddEvent = false
    @State private var selectedView = CalendarViewType.month
    
    enum CalendarViewType: String, CaseIterable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
    }
    
    var body: some View {
        NavigationView {
            // Sidebar with events
            EventSidebar(document: $document, showingAddEvent: $showingAddEvent)
                .frame(minWidth: 250, maxWidth: 300)
            
            // Main calendar view
            VStack(spacing: 0) {
                // Header with view selector
                HStack {
                    Text("Calendar")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Picker("View", selection: $selectedView) {
                        ForEach(CalendarViewType.allCases, id: \.self) { viewType in
                            Text(viewType.rawValue).tag(viewType)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                
                // Calendar content
                Group {
                    switch selectedView {
                    case .day:
                        DayView(document: $document)
                    case .week:
                        WeekView(document: $document)
                    case .month:
                        MonthView(document: $document)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddEvent = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventView(document: $document)
        }
    }
}

struct EventSidebar: View {
    @Binding var document: PRJ_2030Document
    @Binding var showingAddEvent: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(selectedDateString)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: { showingAddEvent = true }) {
                    Image(systemName: "plus")
                        .font(.caption)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            // Events list
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(eventsForSelectedDate, id: \.id) { event in
                        EventRow(event: event, document: $document)
                    }
                    
                    if eventsForSelectedDate.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)
                            
                            Text("No Events")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Click the + button to add an event")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    }
                }
                .padding()
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: document.selectedDate)
    }
    
    private var eventsForSelectedDate: [CalendarEvent] {
        return document.events.filter { event in
            calendar.isDate(event.startDate, inSameDayAs: document.selectedDate)
        }.sorted { $0.startDate < $1.startDate }
    }
}

struct EventRow: View {
    let event: CalendarEvent
    @Binding var document: PRJ_2030Document
    @State private var showingEventDetail = false
    
    var body: some View {
        Button(action: { showingEventDetail = true }) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Rectangle()
                        .fill(event.color.color)
                        .frame(width: 4, height: 16)
                        .cornerRadius(2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.title)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        if let location = event.location {
                            Text(location)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        
                        if !event.isAllDay {
                            Text(timeString)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("All Day")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(8)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingEventDetail) {
            EventDetailView(event: event, document: $document)
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: event.startDate)) - \(formatter.string(from: event.endDate))"
    }
}



struct MonthView: View {
    @Binding var document: PRJ_2030Document
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let daysInWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Month navigation
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            // Day headers
            HStack(spacing: 0) {
                ForEach(daysInWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
            .background(Color(NSColor.controlBackgroundColor))
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
                ForEach(calendarDays, id: \.self) { date in
                    DayCell(
                        date: date,
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        isSelected: calendar.isDate(date, inSameDayAs: document.selectedDate),
                        events: eventsForDate(date)
                    ) {
                        document.selectedDate = date
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var calendarDays: [Date] {
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let startDate = calendar.date(byAdding: .day, value: -(firstWeekday - 1), to: startOfMonth) ?? startOfMonth
        
        var days: [Date] = []
        for i in 0..<42 {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                days.append(date)
            }
        }
        return days
    }
    
    private func eventsForDate(_ date: Date) -> [CalendarEvent] {
        return document.events.filter { event in
            calendar.isDate(event.startDate, inSameDayAs: date)
        }
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newDate
        }
    }
}

struct DayCell: View {
    let date: Date
    let isCurrentMonth: Bool
    let isSelected: Bool
    let events: [CalendarEvent]
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                .foregroundColor(isCurrentMonth ? (isSelected ? .white : .primary) : .secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
            
            // Event indicators
            VStack(spacing: 1) {
                ForEach(events.prefix(3), id: \.id) { event in
                    Rectangle()
                        .fill(event.color.color)
                        .frame(height: 2)
                        .cornerRadius(1)
                }
            }
            .padding(.horizontal, 4)
            
            Spacer()
        }
        .frame(height: 60)
        .background(isSelected ? Color.accentColor : Color.clear)
        .cornerRadius(6)
        .onTapGesture {
            onTap()
        }
    }
}

// WeekView is now in a separate file

// DayView is now in a separate file

#Preview {
    ContentView(document: .constant(PRJ_2030Document()))
}
