public enum SimulatedHeartRateZone: CaseIterable, Equatable, Sendable {
    case zone1
    case zone2
    case zone3
}

public struct CadenceController: Equatable, Sendable {
    public init() {}

    public func targetStepsPerMinute(
        currentStepsPerMinute: Int,
        minimumStepsPerMinute: Int,
        maximumStepsPerMinute: Int,
        adjustmentStep: Int,
        simulatedZone: SimulatedHeartRateZone
    ) -> Int {
        let lowerCadenceLimit = min(minimumStepsPerMinute, maximumStepsPerMinute)
        let upperCadenceLimit = max(minimumStepsPerMinute, maximumStepsPerMinute)
        let cadenceLimits = lowerCadenceLimit...upperCadenceLimit
        let safeAdjustmentStep = max(adjustmentStep, 0)
        let boundedCurrent = currentStepsPerMinute.clamped(
            to: cadenceLimits
        )

        let adjustedStepsPerMinute: Int
        switch simulatedZone {
        case .zone1:
            adjustedStepsPerMinute = boundedCurrent + safeAdjustmentStep
        case .zone2:
            adjustedStepsPerMinute = boundedCurrent
        case .zone3:
            adjustedStepsPerMinute = boundedCurrent - safeAdjustmentStep
        }

        return adjustedStepsPerMinute.clamped(
            to: cadenceLimits
        )
    }
}

private extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
