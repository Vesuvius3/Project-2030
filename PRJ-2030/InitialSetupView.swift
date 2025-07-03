
import SwiftUI

struct InitialSetupView: View {
    @State private var selectedDate: Date = Date()
    @State private var showMainAppView: Bool = false

    var body: some View {
        Group {
            if showMainAppView {
                MainAppView(targetDate: selectedDate)
            } else {
                VStack {
                    Spacer()

                    Text("Welcome, time traveler! Let's embark on a journey to a future moment.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()

                    Text("Choose a date in the future, and we'll count down to it with a quirky visual.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)

                    DatePicker(
                        "Select a Future Date",
                        selection: $selectedDate,
                        in: Date()..., // Ensures only future dates can be selected
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    .frame(maxWidth: 400) // Limit width for better appearance

                    Button("Begin the Countdown!") {
                        showMainAppView = true
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.top, 30)

                    Spacer()
                }
            }
        }
        .animation(.default, value: showMainAppView)
    }
}

struct InitialSetupView_Previews: PreviewProvider {
    static var previews: some View {
        InitialSetupView()
    }
}
