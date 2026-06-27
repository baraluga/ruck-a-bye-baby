import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section("Ruck settings") {
                    LabeledContent("Zone 2 heart rate", value: "Not configured")
                    LabeledContent("Cadence range", value: "100-160 SPM")
                }
            }
            .navigationTitle("Ruck-a-Bye")
        }
    }
}

#Preview {
    ContentView()
}
