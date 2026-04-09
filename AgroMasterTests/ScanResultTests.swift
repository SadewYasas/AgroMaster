import XCTest
@testable import AgroMaster

final class ScanResultTests: XCTestCase {

    // MARK: - ScanResultData Creation

    func testScanResultData_canBeCreatedWithAllFields() {
        let treatments = [
            Treatment(category: "Chemical", description: "Apply fungicide"),
            Treatment(category: "Pruning", description: "Remove infected leaves")
        ]
        let result = ScanResultData(
            plantName: "Tomato",
            diseaseName: "Early Blight",
            healthScore: 0.42,
            treatments: treatments,
            scanDate: Date()
        )

        XCTAssertEqual(result.plantName, "Tomato")
        XCTAssertEqual(result.diseaseName, "Early Blight")
        XCTAssertEqual(result.healthScore, 0.42, accuracy: 0.001)
        XCTAssertEqual(result.treatments.count, 2)
        XCTAssertNotNil(result.scanDate)
    }

    func testScanResultData_withNilDiseaseName_representsHealthyPlant() {
        let result = ScanResultData(
            plantName: "Basil",
            diseaseName: nil,
            healthScore: 0.95,
            treatments: [],
            scanDate: Date()
        )

        XCTAssertEqual(result.plantName, "Basil")
        XCTAssertNil(result.diseaseName)
        XCTAssertGreaterThan(result.healthScore, 0.9)
    }

    func testScanResultData_healthScoreWithinValidRange() {
        let result = ScanResultData(
            plantName: "Rose",
            diseaseName: "Leaf Spot",
            healthScore: 0.614,
            treatments: [],
            scanDate: Date()
        )

        XCTAssertGreaterThanOrEqual(result.healthScore, 0.0)
        XCTAssertLessThanOrEqual(result.healthScore, 1.0)
    }

    func testScanResultData_scanDateIsRecorded() {
        let beforeDate = Date()
        let result = ScanResultData(
            plantName: "Cucumber",
            diseaseName: "Powdery Mildew",
            healthScore: 0.736,
            treatments: [],
            scanDate: Date()
        )
        let afterDate = Date()

        XCTAssertGreaterThanOrEqual(result.scanDate, beforeDate)
        XCTAssertLessThanOrEqual(result.scanDate, afterDate)
    }

    // MARK: - Treatment

    func testTreatment_hasUniqueIDs() {
        let t1 = Treatment(category: "Chemical", description: "Apply fungicide")
        let t2 = Treatment(category: "Chemical", description: "Apply fungicide")

        // Even with identical content, IDs should differ
        XCTAssertNotEqual(t1.id, t2.id)
    }

    func testTreatment_storesCategory() {
        let treatment = Treatment(category: "Pruning", description: "Remove infected leaves")
        XCTAssertEqual(treatment.category, "Pruning")
    }

    func testTreatment_storesDescription() {
        let treatment = Treatment(category: "Soil Health", description: "Add organic mulch")
        XCTAssertEqual(treatment.description, "Add organic mulch")
    }

    func testTreatment_idIsNotNil() {
        let treatment = Treatment(category: "Follow-Up", description: "Re-scan in 7 days")
        XCTAssertNotNil(treatment.id)
    }

    // MARK: - Multiple Treatments

    func testScanResultData_multipleTreatments() {
        let treatments = [
            Treatment(category: "Chemical Control", description: "Apply chlorothalonil"),
            Treatment(category: "Pruning", description: "Remove infected lower leaves"),
            Treatment(category: "Soil Health", description: "Add organic mulch"),
            Treatment(category: "Follow-Up Scan", description: "Re-scan in 5-7 days")
        ]
        let result = ScanResultData(
            plantName: "Tomato",
            diseaseName: "Early Blight",
            healthScore: 0.42,
            treatments: treatments,
            scanDate: Date()
        )

        XCTAssertEqual(result.treatments.count, 4)
        XCTAssertEqual(result.treatments[0].category, "Chemical Control")
        XCTAssertEqual(result.treatments[3].category, "Follow-Up Scan")
    }

    func testScanResultData_emptyTreatments() {
        let result = ScanResultData(
            plantName: "Basil",
            diseaseName: nil,
            healthScore: 0.95,
            treatments: [],
            scanDate: Date()
        )

        XCTAssertTrue(result.treatments.isEmpty)
    }

    // MARK: - Treatment Unique IDs in Array

    func testTreatments_allIDsAreUnique() {
        let treatments = [
            Treatment(category: "A", description: "Desc A"),
            Treatment(category: "B", description: "Desc B"),
            Treatment(category: "C", description: "Desc C")
        ]
        let ids = treatments.map { $0.id }
        let uniqueIDs = Set(ids)

        XCTAssertEqual(ids.count, uniqueIDs.count, "All treatment IDs should be unique")
    }
}
