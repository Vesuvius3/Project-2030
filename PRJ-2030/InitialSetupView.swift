
import SwiftUI

struct InitialSetupView: View {
    @State private var selectedDate: Date = Date()
    @State private var showMainAppView: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("Welcome, time traveler! Let's embark on a journey to a future moment.")
                    .font(.americanTypewriter(size: 34))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                Text("Choose a date in the future, and we'll count down to it with a quirky visual.")
                    .font(.americanTypewriter(size: 22))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)

                DatePicker(
                    "Select a Future Date",
                    selection: $selectedDate,
                    in: Date()..., // Ensures only future dates can be selected
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .font(.americanTypewriter(size: 18))
                .padding()
                .frame(maxWidth: 400) // Limit width for better appearance

                Button("Begin the Countdown!") {
                    showMainAppView = true
                }
                .font(.americanTypewriter(size: 22))
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.top, 30)

                Spacer()
            }
            .navigationTitle("")
            .navigationTitle("")
            .background(
                NavigationLink(
                    destination: MainAppView(targetDate: selectedDate),
                    isActive: $showMainAppView,
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }
}

struct InitialSetupView_Previews: PreviewProvider {
    static var previews: some View {
        InitialSetupView()
    }
}
