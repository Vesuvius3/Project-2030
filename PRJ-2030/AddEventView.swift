//
//  AddEventView.swift
//  PRJ-2030
//
//  Created by Hammad Rashid on 7/1/25.
//

import SwiftUI

struct AddEventView: View {
    @Binding var document: PRJ_2030Document
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600) // 1 hour later
    @State private var location = ""
    @State private var notes = ""
    @State private var selectedColor: CodableColor = CodableColor(color: .blue)
    @State private var isAllDay = false
    
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
                    ColorPickerView(selectedColor: $selectedColor)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("New Event")
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addEvent()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .frame(width: 400, height: 500)
    }
    
    private func addEvent() {
        let event = CalendarEvent(
            title: title,
            startDate: startDate,
            endDate: isAllDay ? startDate : endDate,
            location: location.isEmpty ? nil : location,
            notes: notes.isEmpty ? nil : notes,
            color: selectedColor.color,
            isAllDay: isAllDay
        )
        
        document.events.append(event)
        dismiss()
    }
}

#Preview {
    AddEventView(document: .constant(PRJ_2030Document()))
} 