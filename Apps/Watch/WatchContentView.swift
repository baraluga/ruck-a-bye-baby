import SwiftUI

struct WatchContentView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Ruck-a-Bye")
                .font(.headline)
            Text("Ready")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .containerBackground(.fill.tertiary, for: .navigation)
    }
}

#Preview {
    WatchContentView()
}
