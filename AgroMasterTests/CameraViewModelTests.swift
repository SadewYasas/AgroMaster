import XCTest
@testable import AgroMaster

@MainActor
final class CameraViewModelTests: XCTestCase {

    private var viewModel: CameraViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CameraViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func testInitialState_selectedImageIsNil() {
        XCTAssertNil(viewModel.selectedImage)
    }

    func testInitialState_isAnalyzingIsFalse() {
        XCTAssertFalse(viewModel.isAnalyzing)
    }

    func testInitialState_scanResultIsNil() {
        XCTAssertNil(viewModel.scanResult)
    }

    func testInitialState_showResultIsFalse() {
        XCTAssertFalse(viewModel.showResult)
    }

    func testInitialState_photoPickerItemIsNil() {
        XCTAssertNil(viewModel.photoPickerItem)
    }

    // MARK: - loadSampleImage

    func testLoadSampleImage_setsSelectedImage() {
        viewModel.loadSampleImage()
        XCTAssertNotNil(viewModel.selectedImage)
    }

    func testLoadSampleImage_imageHasExpectedSize() {
        viewModel.loadSampleImage()
        let image = viewModel.selectedImage
        XCTAssertNotNil(image)
        XCTAssertEqual(image?.size.width, 400)
        XCTAssertEqual(image?.size.height, 400)
    }

    func testLoadSampleImage_calledTwice_stillHasImage() {
        viewModel.loadSampleImage()
        viewModel.loadSampleImage()
        XCTAssertNotNil(viewModel.selectedImage)
    }

    // MARK: - reset

    func testReset_clearsSelectedImage() {
        viewModel.loadSampleImage()
        XCTAssertNotNil(viewModel.selectedImage)

        viewModel.reset()
        XCTAssertNil(viewModel.selectedImage)
    }

    func testReset_clearsAllState() {
        viewModel.loadSampleImage()
        viewModel.reset()

        XCTAssertNil(viewModel.selectedImage)
        XCTAssertNil(viewModel.scanResult)
        XCTAssertFalse(viewModel.showResult)
        XCTAssertFalse(viewModel.isAnalyzing)
        XCTAssertNil(viewModel.photoPickerItem)
    }

    func testReset_onAlreadyCleanState_remainsClean() {
        viewModel.reset()

        XCTAssertNil(viewModel.selectedImage)
        XCTAssertNil(viewModel.scanResult)
        XCTAssertFalse(viewModel.showResult)
        XCTAssertFalse(viewModel.isAnalyzing)
    }

    // MARK: - analyzeImage Without Image

    func testAnalyzeImage_withoutImage_doesNotStartAnalyzing() {
        viewModel.analyzeImage()
        // analyzeImage guards on selectedImage != nil, so isAnalyzing should stay false
        XCTAssertFalse(viewModel.isAnalyzing)
    }
}
