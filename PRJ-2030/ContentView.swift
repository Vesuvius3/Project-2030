
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

    var body: some View {
        VStack {
            TabView {
                DayView(document: $document)
                    .tabItem {
                        Label("Day", systemImage: "sun.max.fill")
                    }
                
                WeekView(document: $document)
                    .tabItem {
                        Label("Week", systemImage: "calendar")
                    }
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

#Preview {
    ContentView(document: .constant(PRJ_2030Document()))
}
