
//
//  EventDetailView.swift
//  PRJ-2030
//
//  Created by Hammad Rashid on 7/1/25.
//

import SwiftUI

struct EventDetailView: View {
    let event: CalendarEvent
    @Binding var document: PRJ_2030Document
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditEvent = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                        Text(timeString)
                            .foregroundColor(.secondary)
                    }
                    
                    if let location = event.location {
                        HStack {
                            Image(systemName: "location")
                                .foregroundColor(.secondary)
                            Text(location)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if let notes = event.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        
                        Text(notes)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Event Details")
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Edit") {
                        showingEditEvent = true
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 400, height: 300)
        .sheet(isPresented: $showingEditEvent) {
            EditEventView(document: $document, event: event)
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        if event.isAllDay {
            formatter.dateStyle = .medium
            return formatter.string(from: event.startDate)
        } else {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return "\(formatter.string(from: event.startDate)) - \(formatter.string(from: event.endDate))"
        }
    }
}
