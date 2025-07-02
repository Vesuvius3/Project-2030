# Apple Calendar Clone

A modern, feature-rich calendar application built with SwiftUI for macOS that mimics the functionality and design of Apple Calendar.

## Features

### 📅 Multiple View Modes
- **Month View**: Traditional calendar grid showing the entire month with event indicators
- **Week View**: Detailed week view with hourly time slots and event blocks
- **Day View**: Single day view with detailed hourly breakdown

### 🎯 Event Management
- **Create Events**: Add new events with title, date/time, location, notes, and color coding
- **Edit Events**: Modify existing events with full editing capabilities
- **Delete Events**: Remove events with confirmation
- **Event Details**: View comprehensive event information in a dedicated detail view

### 🎨 Visual Design
- **Modern UI**: Clean, Apple-style interface with proper spacing and typography
- **Color Coding**: 8 different colors for event categorization
- **Event Indicators**: Visual indicators in month view showing event presence
- **Responsive Layout**: Adapts to different window sizes

### 📱 User Experience
- **Sidebar**: Shows events for the selected date with quick access to event details
- **Navigation**: Easy navigation between months, weeks, and days
- **Date Selection**: Click any date to select and view its events
- **Sample Data**: Pre-loaded sample events to demonstrate functionality

### 💾 Data Persistence
- **Document-Based**: Uses macOS document architecture for file management
- **Auto-Save**: Automatic saving of calendar data
- **Export/Import**: Save and load calendar files

## Technical Details

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **Document-Based App**: Follows macOS document architecture
- **MVVM Pattern**: Clean separation of data and presentation logic

### Key Components
- `PRJ_2030Document`: Main document model storing events and selected date
- `CalendarEvent`: Event model with all necessary properties
- `ContentView`: Main application view with navigation and sidebar
- `MonthView`: Monthly calendar grid implementation
- `WeekView`: Weekly view with hourly breakdown
- `DayView`: Daily view with detailed time slots
- `AddEventView`: Event creation interface
- `EditEventView`: Event editing interface
- `EventDetailView`: Event information display

### Data Model
```swift
struct CalendarEvent: Identifiable, Codable {
    let id = UUID()
    var title: String
    var startDate: Date
    var endDate: Date
    var location: String?
    var notes: String?
    var color: String
    var isAllDay: Bool
}
```

## Getting Started

1. Open the project in Xcode
2. Build and run the application
3. The app will start with sample events loaded
4. Use the view selector to switch between Month, Week, and Day views
5. Click the + button to add new events
6. Click on events to view details or edit them

## Usage

### Adding Events
1. Click the + button in the toolbar or sidebar
2. Fill in the event details (title is required)
3. Choose a color for the event
4. Set the date and time
5. Add optional location and notes
6. Click "Add" to save

### Navigating the Calendar
- Use the arrow buttons to navigate between months/weeks/days
- Click on any date to select it and view its events
- Use the view selector to switch between different calendar views

### Managing Events
- Click on any event to view its details
- Use the "Edit" button in event details to modify events
- Delete events using the "Delete Event" button in the edit view

## Requirements

- macOS 13.0 or later
- Xcode 14.0 or later
- Swift 5.7 or later

## Future Enhancements

- Recurring events
- Calendar sharing
- Multiple calendar support
- Event reminders and notifications
- Integration with system calendar
- Dark mode support
- Accessibility improvements

## License

This project is created for educational purposes and demonstrates modern SwiftUI development practices for macOS applications. 