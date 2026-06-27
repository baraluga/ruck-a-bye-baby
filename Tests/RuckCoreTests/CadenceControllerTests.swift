import XCTest
@testable import RuckCore

final class CadenceControllerTests: XCTestCase {
    private let controller = CadenceController()

    func testZoneOneIncreasesCadenceByOneAdjustmentStep() {
        let target = controller.targetStepsPerMinute(
            currentStepsPerMinute: 120,
            minimumStepsPerMinute: 100,
            maximumStepsPerMinute: 160,
            adjustmentStep: 2,
            simulatedZone: .zone1
        )

        XCTAssertEqual(target, 122)
    }

    func testZoneTwoMaintainsCadence() {
        let target = controller.targetStepsPerMinute(
            currentStepsPerMinute: 120,
            minimumStepsPerMinute: 100,
            maximumStepsPerMinute: 160,
            adjustmentStep: 2,
            simulatedZone: .zone2
        )

        XCTAssertEqual(target, 120)
    }

    func testZoneThreeDecreasesCadenceByOneAdjustmentStep() {
        let target = controller.targetStepsPerMinute(
            currentStepsPerMinute: 120,
            minimumStepsPerMinute: 100,
            maximumStepsPerMinute: 160,
            adjustmentStep: 2,
            simulatedZone: .zone3
        )

        XCTAssertEqual(target, 118)
    }

    func testZoneOneRespectsMaximumCadence() {
        let target = controller.targetStepsPerMinute(
            currentStepsPerMinute: 159,
            minimumStepsPerMinute: 100,
            maximumStepsPerMinute: 160,
            adjustmentStep: 4,
            simulatedZone: .zone1
        )

        XCTAssertEqual(target, 160)
    }

    func testZoneThreeRespectsMinimumCadence() {
        let target = controller.targetStepsPerMinute(
            currentStepsPerMinute: 101,
            minimumStepsPerMinute: 100,
            maximumStepsPerMinute: 160,
            adjustmentStep: 4,
            simulatedZone: .zone3
        )

        XCTAssertEqual(target, 100)
    }
}
