//
//  PRJ_2030Document.swift
//  PRJ-2030
//
//  Created by Hammad Rashid on 7/1/25.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation

extension UTType {
    static var calendarData: UTType {
        UTType(importedAs: "com.example.calendar-data")
    }
}

struct CodableColor: Codable, Hashable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
    
    init(color: Color) {
        #if os(macOS)
        let nsColor = NSColor(color)
        self.red = Double(nsColor.redComponent)
        self.green = Double(nsColor.greenComponent)
        self.blue = Double(nsColor.blueComponent)
        self.alpha = Double(nsColor.alphaComponent)
        #else
        // Fallback for other platforms if needed
        self.red = 0
        self.green = 0
        self.blue = 0
        self.alpha = 1
        #endif
    }
    
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}

struct CalendarEvent: Identifiable, Codable {
    var id = UUID()
    var title: String
    var startDate: Date
    var endDate: Date
    var location: String?
    var notes: String?
    var color: CodableColor
    var isAllDay: Bool
    
    init(title: String, startDate: Date, endDate: Date, location: String? = nil, notes: String? = nil, color: Color = .blue, isAllDay: Bool = false) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.notes = notes
        self.color = CodableColor(color: color)
        self.isAllDay = isAllDay
    }
}

struct PRJ_2030Document: FileDocument, Codable {
    var events: [CalendarEvent]
    var selectedDate: Date

    init(events: [CalendarEvent] = [], selectedDate: Date = Date()) {
        self.events = events
        self.selectedDate = selectedDate
    }

    static var readableContentTypes: [UTType] { [.calendarData] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self = try JSONDecoder().decode(PRJ_2030Document.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return .init(regularFileWithContents: data)
    }
}
