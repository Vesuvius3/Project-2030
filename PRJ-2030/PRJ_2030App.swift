//
//  PRJ_2030App.swift
//  PRJ-2030
//
//  Created by Hammad Rashid on 7/1/25.
//

import SwiftUI

@main
struct PRJ_2030App: App {
    var body: some Scene {
        WindowGroup {
            InitialSetupView()
                .environment(\.font, .americanTypewriter(size: 17))
        }
        .accentColor(.gray)
    }
}
