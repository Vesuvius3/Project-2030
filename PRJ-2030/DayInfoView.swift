import SwiftUI

struct DayInfo: Identifiable {
    let id: Int
    var notes: String = ""
    var completed: Bool = false
}

struct DayInfoView: View {
    @Binding var info: DayInfo
    var onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button("Back") { onBack() }
                Spacer()
            }
            .padding(.bottom)

            Form {
                Section("Notes") {
                    TextEditor(text: $info.notes)
                        .frame(minHeight: 150)
                }

                Toggle("Completed", isOn: $info.completed)
            }
        }
        .padding()
    }
}

#Preview {
    DayInfoView(info: .constant(DayInfo(id: 0)), onBack: {})
}
