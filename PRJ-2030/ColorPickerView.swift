import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: CodableColor
    
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
    
    var body: some View {
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
}
