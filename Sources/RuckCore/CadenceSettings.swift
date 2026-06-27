public struct CadenceSettings: Equatable, Sendable {
    public static let supportedStepsPerMinute = 60...220

    public var startingStepsPerMinute: Int
    public var minimumStepsPerMinute: Int
    public var maximumStepsPerMinute: Int
    public var adjustmentStep: Int

    public init(
        startingStepsPerMinute: Int = 120,
        minimumStepsPerMinute: Int = 100,
        maximumStepsPerMinute: Int = 160,
        adjustmentStep: Int = 2
    ) {
        self.startingStepsPerMinute = startingStepsPerMinute
        self.minimumStepsPerMinute = minimumStepsPerMinute
        self.maximumStepsPerMinute = maximumStepsPerMinute
        self.adjustmentStep = adjustmentStep
    }

    public var isValid: Bool {
        validationIssues().isEmpty
    }

    public func validate() throws {
        let issues = validationIssues()
        if !issues.isEmpty {
            throw CadenceSettingsValidationError(issues: issues)
        }
    }

    public func validationIssues() -> [CadenceSettingsIssue] {
        var issues: [CadenceSettingsIssue] = []
        let supportedRange = Self.supportedStepsPerMinute

        if minimumStepsPerMinute < supportedRange.lowerBound {
            issues.append(.minimumBelowSupported(minimumStepsPerMinute))
        }

        if maximumStepsPerMinute > supportedRange.upperBound {
            issues.append(.maximumAboveSupported(maximumStepsPerMinute))
        }

        if minimumStepsPerMinute > maximumStepsPerMinute {
            issues.append(.minimumExceedsMaximum(
                minimum: minimumStepsPerMinute,
                maximum: maximumStepsPerMinute
            ))
        }

        if startingStepsPerMinute < minimumStepsPerMinute || startingStepsPerMinute > maximumStepsPerMinute {
            issues.append(.startingOutsideBounds(
                starting: startingStepsPerMinute,
                minimum: minimumStepsPerMinute,
                maximum: maximumStepsPerMinute
            ))
        }

        if adjustmentStep <= 0 {
            issues.append(.adjustmentStepNotPositive(adjustmentStep))
        }

        return issues
    }
}

public enum CadenceSettingsIssue: Equatable, Sendable, CustomStringConvertible {
    case minimumBelowSupported(Int)
    case maximumAboveSupported(Int)
    case minimumExceedsMaximum(minimum: Int, maximum: Int)
    case startingOutsideBounds(starting: Int, minimum: Int, maximum: Int)
    case adjustmentStepNotPositive(Int)

    public var description: String {
        switch self {
        case let .minimumBelowSupported(value):
            return "Minimum cadence \(value) is below \(CadenceSettings.supportedStepsPerMinute.lowerBound) SPM."
        case let .maximumAboveSupported(value):
            return "Maximum cadence \(value) is above \(CadenceSettings.supportedStepsPerMinute.upperBound) SPM."
        case let .minimumExceedsMaximum(minimum, maximum):
            return "Minimum cadence \(minimum) must not exceed maximum cadence \(maximum)."
        case let .startingOutsideBounds(starting, minimum, maximum):
            return "Starting cadence \(starting) must be between \(minimum) and \(maximum) SPM."
        case let .adjustmentStepNotPositive(value):
            return "Adjustment step \(value) must be greater than zero."
        }
    }
}

public struct CadenceSettingsValidationError: Error, Equatable, Sendable {
    public let issues: [CadenceSettingsIssue]

    public init(issues: [CadenceSettingsIssue]) {
        self.issues = issues
    }
}
