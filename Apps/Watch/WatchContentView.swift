import RuckCore
import SwiftUI
#if os(watchOS)
import AVFoundation
#endif

struct WatchContentView: View {
    @StateObject private var metronome = WatchMetronomeViewModel()

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Ruck-a-Bye")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(metronome.isRunning ? "LIVE" : "READY")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(metronome.isRunning ? .green : .secondary)
            }

            ZStack {
                Circle()
                    .fill(metronome.isRunning ? Color.green.opacity(0.22) : Color.gray.opacity(0.14))
                    .scaleEffect(metronome.pulseScale)
                    .overlay {
                        Circle()
                            .stroke(
                                metronome.isRunning ? Color.green : Color.secondary.opacity(0.4),
                                lineWidth: 3
                            )
                    }
                    .animation(.easeOut(duration: 0.16), value: metronome.pulseCount)

                VStack(spacing: 0) {
                    Text("\(metronome.currentStepsPerMinute)")
                        .font(.system(size: 33, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("SPM")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 76, height: 76)

            Text(metronome.simulatedZone.title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(metronome.simulatedZone.tint)

            Button {
                metronome.toggleRunning()
            } label: {
                Label(
                    metronome.isRunning ? "Stop" : "Start",
                    systemImage: metronome.isRunning ? "stop.fill" : "play.fill"
                )
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .tint(metronome.isRunning ? .red : .green)

            HStack(spacing: 5) {
                ForEach(SimulatedHeartRateZone.allCases, id: \.self) { zone in
                    Button {
                        metronome.setSimulatedZone(zone)
                    } label: {
                        Text(zone.shortTitle)
                            .font(.caption2.weight(.bold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(metronome.simulatedZone == zone ? zone.tint : .secondary)
                    .accessibilityLabel(zone.title)
                }
            }
            .controlSize(.small)
        }
        .padding(.horizontal, 8)
        .containerBackground(.fill.tertiary, for: .navigation)
    }
}

#Preview {
    WatchContentView()
}

@MainActor
private final class WatchMetronomeViewModel: ObservableObject {
    @Published private(set) var currentStepsPerMinute: Int
    @Published private(set) var simulatedZone: SimulatedHeartRateZone = .zone2
    @Published private(set) var isRunning = false
    @Published private(set) var pulseCount = 0

    private let settings = CadenceSettings()
    private let controller = CadenceController()
    private var metronomeTask: Task<Void, Never>?

    init() {
        currentStepsPerMinute = settings.startingStepsPerMinute
    }

    var pulseScale: Double {
        guard isRunning else { return 0.8 }
        return pulseCount.isMultiple(of: 2) ? 1.0 : 0.72
    }

    func toggleRunning() {
        if isRunning {
            stop()
        } else {
            start()
        }
    }

    func setSimulatedZone(_ zone: SimulatedHeartRateZone) {
        simulatedZone = zone
        currentStepsPerMinute = controller.targetStepsPerMinute(
            currentStepsPerMinute: currentStepsPerMinute,
            minimumStepsPerMinute: settings.minimumStepsPerMinute,
            maximumStepsPerMinute: settings.maximumStepsPerMinute,
            adjustmentStep: settings.adjustmentStep,
            simulatedZone: zone
        )

        if isRunning {
            startMetronomeLoop()
        }
    }

    private func start() {
        guard !isRunning else { return }

        isRunning = true
        startMetronomeLoop()
    }

    private func stop() {
        isRunning = false
        metronomeTask?.cancel()
        metronomeTask = nil
        pulseCount = 0
    }

    private func startMetronomeLoop() {
        metronomeTask?.cancel()
        metronomeTask = Task { @MainActor [weak self] in
            guard let self else { return }

            while !Task.isCancelled {
                tick()

                do {
                    try await Task.sleep(nanoseconds: tickDelayNanoseconds)
                } catch {
                    return
                }
            }
        }
    }

    private func tick() {
        pulseCount += 1
        WatchMetronomeFeedback.playTick()
    }

    private var tickDelayNanoseconds: UInt64 {
        let secondsPerStep = 60.0 / Double(currentStepsPerMinute)
        return UInt64(secondsPerStep * 1_000_000_000)
    }
}

@MainActor
private enum WatchMetronomeFeedback {
    #if os(watchOS)
    private static let audioPlayer = WatchTickAudioPlayer()
    #endif

    static func playTick() {
        #if os(watchOS)
        _ = audioPlayer.playTick()
        #endif
    }
}

#if os(watchOS)
private final class WatchTickAudioPlayer {
    private var player: AVAudioPlayer?
    private var didAttemptSetup = false

    func playTick() -> Bool {
        if player == nil, !didAttemptSetup {
            didAttemptSetup = true
            player = makePlayer()
        }

        guard let player else { return false }

        player.currentTime = 0
        return player.play()
    }

    private func makePlayer() -> AVAudioPlayer? {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)

            let player = try AVAudioPlayer(data: Self.tickWaveData())
            player.prepareToPlay()
            player.volume = 1
            return player
        } catch {
            return nil
        }
    }

    private static func tickWaveData() -> Data {
        let sampleRate = 16_000
        let duration = 0.035
        let frameCount = Int(Double(sampleRate) * duration)
        let bytesPerSample = 2
        let dataByteCount = frameCount * bytesPerSample

        var data = Data()
        data.appendASCII("RIFF")
        data.appendLittleEndianUInt32(UInt32(36 + dataByteCount))
        data.appendASCII("WAVE")
        data.appendASCII("fmt ")
        data.appendLittleEndianUInt32(16)
        data.appendLittleEndianUInt16(1)
        data.appendLittleEndianUInt16(1)
        data.appendLittleEndianUInt32(UInt32(sampleRate))
        data.appendLittleEndianUInt32(UInt32(sampleRate * bytesPerSample))
        data.appendLittleEndianUInt16(UInt16(bytesPerSample))
        data.appendLittleEndianUInt16(UInt16(bytesPerSample * 8))
        data.appendASCII("data")
        data.appendLittleEndianUInt32(UInt32(dataByteCount))

        for frame in 0..<frameCount {
            let progress = Double(frame) / Double(frameCount)
            let envelope = max(0, 1 - progress)
            let sample = sin(2 * .pi * 1_600 * Double(frame) / Double(sampleRate))
            let value = Int16(sample * envelope * Double(Int16.max) * 0.55)
            data.appendLittleEndianInt16(value)
        }

        return data
    }
}

private extension Data {
    mutating func appendASCII(_ string: String) {
        append(contentsOf: string.utf8)
    }

    mutating func appendLittleEndianUInt16(_ value: UInt16) {
        appendLittleEndianBytes(value.littleEndian)
    }

    mutating func appendLittleEndianUInt32(_ value: UInt32) {
        appendLittleEndianBytes(value.littleEndian)
    }

    mutating func appendLittleEndianInt16(_ value: Int16) {
        appendLittleEndianBytes(value.littleEndian)
    }

    private mutating func appendLittleEndianBytes<T>(_ value: T) {
        var mutableValue = value
        Swift.withUnsafeBytes(of: &mutableValue) { buffer in
            append(contentsOf: buffer)
        }
    }
}
#endif

private extension SimulatedHeartRateZone {
    var title: String {
        switch self {
        case .zone1:
            return "Zone 1: bump up"
        case .zone2:
            return "Zone 2: hold"
        case .zone3:
            return "Zone 3: ease down"
        }
    }

    var shortTitle: String {
        switch self {
        case .zone1:
            return "Z1"
        case .zone2:
            return "Z2"
        case .zone3:
            return "Z3"
        }
    }

    var tint: Color {
        switch self {
        case .zone1:
            return .blue
        case .zone2:
            return .green
        case .zone3:
            return .orange
        }
    }
}
