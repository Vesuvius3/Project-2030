
import SwiftUI

struct MainAppView: View {
    let targetDate: Date
    @State private var daysRemaining: Int = 0
    @State private var countdownString: String = ""

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack {
            // Left side: Grid of cells
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 20, maximum: 40))], spacing: 5) {
                    ForEach(0..<daysRemaining, id: \.self) {
                        _ in
                        Rectangle()
                            .fill(Color.blue.opacity(0.7))
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Right side: Countdown
            VStack {
                Spacer()
                Text("Time until your chosen moment:")
                    .font(.title2)
                    .padding(.bottom, 10)

                Text(countdownString)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()
            }
            .frame(width: 300)
            .padding()
        }
        .onAppear(perform: calculateDaysAndCountdown)
        .onReceive(timer) { _ in
            calculateDaysAndCountdown()
        }
    }

    private func calculateDaysAndCountdown() {
        let calendar = Calendar.current
        let now = Date()

        // Calculate days remaining
        let components = calendar.dateComponents([.day], from: now, to: targetDate)
        daysRemaining = components.day ?? 0
        if daysRemaining < 0 { daysRemaining = 0 } // Ensure it doesn't go negative

        // Calculate full countdown string
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .full
        formatter.zeroFormattingBehavior = .dropAll

        if let countdown = formatter.string(from: now, to: targetDate) {
            countdownString = countdown
        } else {
            countdownString = "Time's up!"
        }

        if now > targetDate {
            countdownString = "Time's up!"
            daysRemaining = 0
        }
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView(targetDate: Calendar.current.date(byAdding: .day, value: 30, to: Date())!)
    }
}
