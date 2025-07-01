//
//  ContentView.swift
//  PRJ-2030
//
//  Created by Hammad Rashid on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: PRJ_2030Document

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(PRJ_2030Document()))
}
