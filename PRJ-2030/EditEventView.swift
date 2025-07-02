//
//  EditEventView.swift
//  PRJ-2030
//
//  Created by Hammad Rashid on 7/1/25.
//

import SwiftUI

struct EditEventView: View {
    @Binding var document: PRJ_2030Document
    let event: CalendarEvent
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var location: String
    @State private var notes: String
    @State private var selectedColor: CodableColor
    @State private var isAllDay: Bool
    
    private let colors: [(String, Color, CodableColor)] = [
        ("blue", .blue, CodableColor(color: .blue)),
        ("red", .red, CodableColor(color: .red)),
        ("green", .green, CodableColor(color: .green)),
        ("orange", .orange, CodableColor(color: .orange)),
        ("purple", .purple, CodableColor(color: .purple)),
        ("pink", .pink, CodableColor(color: .pink)),
        ("yellow", .yellow, CodableColor(color: .yellow)),
        ("gray", .gray, CodableColor(color: .gray))
    ]
    
    init(document: Binding<PRJ_2030Document>, event: CalendarEvent) {
        self._document = document
        self.event = event
        self._title = State(initialValue: event.title)
        self._startDate = State(initialValue: event.startDate)
        self._endDate = State(initialValue: event.endDate)
        self._location = State(initialValue: event.location ?? "")
        self._notes = State(initialValue: event.notes ?? "")
        self._selectedColor = State(initialValue: event.color)
        _isAllDay = State(initialValue: event.isAllDay)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Event Details") {
                    TextField("Event Title", text: $title)
                    
                    Toggle("All Day", isOn: $isAllDay)
                    
                    if !isAllDay {
                        DatePicker("Starts", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                        DatePicker("Ends", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                    } else {
                        DatePicker("Date", selection: $startDate, displayedComponents: [.date])
                    }
                }
                
                Section("Location") {
                    TextField("Location", text: $location)
                }
                
                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                        ForEach(colors, id: \.0) { colorName, color, codableColor in
                            Circle()
                                .fill(color)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == codableColor ? Color.primary : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedColor = codableColor
                                }
                        }
                    }
                    .padding(.vertical, 5)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Button("Delete Event", role: .destructive) {
                        deleteEvent()
                    }
                }
            }
            .navigationTitle("Edit Event")
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        updateEvent()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .frame(width: 400, height: 500)
    }
    
    private func updateEvent() {
        if let index = document.events.firstIndex(where: { $0.id == event.id }) {
            document.events[index] = CalendarEvent(
                title: title,
                startDate: startDate,
                endDate: isAllDay ? startDate : endDate,
                location: location.isEmpty ? nil : location,
                notes: notes.isEmpty ? nil : notes,
                color: selectedColor.color,
                isAllDay: isAllDay
            )
        }
        dismiss()
    }
    
    private func deleteEvent() {
        document.events.removeAll { $0.id == event.id }
        dismiss()
    }
}

#Preview {
    EditEventView(document: .constant(PRJ_2030Document()), event: CalendarEvent(title: "Sample Event", startDate: Date(), endDate: Date().addingTimeInterval(3600)))
} 