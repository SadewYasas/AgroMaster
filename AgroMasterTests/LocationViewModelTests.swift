import XCTest
import MapKit
@testable import AgroMaster

final class LocationViewModelTests: XCTestCase {

    private var viewModel: LocationViewModel!

    override func setUp() {
        super.setUp()
        viewModel = LocationViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Support Centers

    func testSupportCenters_isNotEmptyOnInit() {
        XCTAssertFalse(viewModel.supportCenters.isEmpty)
    }

    func testSupportCenters_containsExpectedCount() {
        XCTAssertEqual(viewModel.supportCenters.count, 5)
    }

    func testSupportCenters_firstCenterIsGreenLeaf() {
        XCTAssertEqual(viewModel.supportCenters.first?.name, "GreenLeaf Agro Center")
    }

    // MARK: - Filtered Centers (empty search)

    func testFilteredCenters_withEmptySearch_returnsAll() {
        viewModel.searchText = ""
        XCTAssertEqual(viewModel.filteredCenters.count, viewModel.supportCenters.count)
    }

    // MARK: - Filtered Centers (by name)

    func testFilteredCenters_byName_returnsMatch() {
        viewModel.searchText = "GreenLeaf"
        let results = viewModel.filteredCenters
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "GreenLeaf Agro Center")
    }

    func testFilteredCenters_byPartialName_returnsMatch() {
        viewModel.searchText = "farm"
        let results = viewModel.filteredCenters
        // "FarmCare Hub" should match
        XCTAssertTrue(results.contains(where: { $0.name == "FarmCare Hub" }))
    }

    func testFilteredCenters_caseInsensitive_returnsMatch() {
        viewModel.searchText = "greenleaf"
        let results = viewModel.filteredCenters
        XCTAssertEqual(results.count, 1)
    }

    func testFilteredCenters_noMatch_returnsEmpty() {
        viewModel.searchText = "XYZNonExistent"
        let results = viewModel.filteredCenters
        XCTAssertTrue(results.isEmpty)
    }

    // MARK: - Filtered Centers (by category)

    func testFilteredCenters_byCategory_returnsMatches() {
        viewModel.searchText = "Pest Management"
        let results = viewModel.filteredCenters
        // "GreenLeaf Agro Center" and "CropGuard Pest Services" have "Pest Management"
        XCTAssertEqual(results.count, 2)
    }

    func testFilteredCenters_byCategoryPartial_returnsMatches() {
        viewModel.searchText = "soil"
        let results = viewModel.filteredCenters
        // "FarmCare Hub" has category "Soil Testing"
        XCTAssertTrue(results.contains(where: { $0.name == "FarmCare Hub" }))
    }

    // MARK: - Default Region

    func testDefaultRegion_isCenteredNearColombo() {
        let center = viewModel.region.center
        XCTAssertEqual(center.latitude, 6.9271, accuracy: 0.1)
        XCTAssertEqual(center.longitude, 79.8612, accuracy: 0.1)
    }

    func testDefaultRegion_hasReasonableSpan() {
        let span = viewModel.region.span
        XCTAssertEqual(span.latitudeDelta, 0.06, accuracy: 0.01)
        XCTAssertEqual(span.longitudeDelta, 0.06, accuracy: 0.01)
    }

    // MARK: - Search Text Default

    func testSearchText_defaultIsEmpty() {
        XCTAssertEqual(viewModel.searchText, "")
    }

    // MARK: - Support Center Properties

    func testSupportCenters_allHaveNonEmptyNames() {
        for center in viewModel.supportCenters {
            XCTAssertFalse(center.name.isEmpty, "Center name should not be empty")
        }
    }

    func testSupportCenters_allHaveCategories() {
        for center in viewModel.supportCenters {
            XCTAssertFalse(center.categories.isEmpty, "Center should have at least one category")
        }
    }
}
