import XCTest
@testable import RuckCore

final class CadenceSettingsTests: XCTestCase {
    func testDefaultCadenceSettingsAreValid() throws {
        XCTAssertTrue(CadenceSettings().isValid)
        XCTAssertNoThrow(try CadenceSettings().validate())
    }

    func testStartingCadenceMustStayInsideConfiguredBounds() {
        let settings = CadenceSettings(
            startingStepsPerMinute: 170,
            minimumStepsPerMinute: 100,
            maximumStepsPerMinute: 160,
            adjustmentStep: 2
        )

        XCTAssertEqual(settings.validationIssues(), [
            .startingOutsideBounds(starting: 170, minimum: 100, maximum: 160)
        ])
    }

    func testCadenceAdjustmentStepMustBePositive() {
        let settings = CadenceSettings(
            startingStepsPerMinute: 120,
            minimumStepsPerMinute: 100,
            maximumStepsPerMinute: 160,
            adjustmentStep: 0
        )

        XCTAssertEqual(settings.validationIssues(), [
            .adjustmentStepNotPositive(0)
        ])
    }
}
