import SwiftUI
import PhotosUI

// MARK: - Data Models

struct ScanResultData {
    let plantName: String
    let diseaseName: String?
    let healthScore: Double
    let treatments: [Treatment]
    let scanDate: Date
}

struct Treatment: Identifiable {
    let id = UUID()
    let category: String
    let description: String
}

// MARK: - Mock Disease Database

private struct DiseaseProfile {
    let plantName: String
    let diseaseName: String?
    let healthScore: Double
    let treatments: [Treatment]
}

private let mockDiseaseProfiles: [DiseaseProfile] = [
    DiseaseProfile(
        plantName: "Tomato",
        diseaseName: "Early Blight",
        healthScore: 0.42,
        treatments: [
            Treatment(category: "Chemical Control", description: "Apply chlorothalonil or copper-based fungicide every 7-10 days. Ensure thorough leaf coverage, especially on lower canopy."),
            Treatment(category: "Pruning", description: "Remove and destroy all infected lower leaves immediately. Prune to improve air circulation between plant stems."),
            Treatment(category: "Soil Health", description: "Add 2-inch layer of organic mulch around the base to prevent soil splash. Supplement with calcium-rich compost."),
            Treatment(category: "Follow-Up Scan", description: "Re-scan in 5-7 days to monitor disease progression. If health score drops below 30%, consider plant removal.")
        ]
    ),
    DiseaseProfile(
        plantName: "Rose",
        diseaseName: "Leaf Spot",
        healthScore: 0.614,
        treatments: [
            Treatment(category: "Chemical Control", description: "Treat with neem oil spray (2 tbsp per gallon) weekly. Alternate with a baking soda solution to prevent resistance."),
            Treatment(category: "Pruning", description: "Cut affected leaves at the stem junction. Sanitize pruning shears with 70% isopropyl alcohol between each cut."),
            Treatment(category: "Soil Health", description: "Improve drainage around root zone. Apply balanced 10-10-10 fertilizer to strengthen plant immune response."),
            Treatment(category: "Follow-Up Scan", description: "Monitor weekly for 3 weeks. Leaf spot typically resolves within 14-21 days with consistent treatment.")
        ]
    ),
    DiseaseProfile(
        plantName: "Cucumber",
        diseaseName: "Powdery Mildew",
        healthScore: 0.736,
        treatments: [
            Treatment(category: "Chemical Control", description: "Apply sulfur-based fungicide or potassium bicarbonate solution. Spray early morning when temperatures are below 90F."),
            Treatment(category: "Pruning", description: "Thin dense foliage to increase sunlight penetration and air flow. Remove the most heavily coated leaves first."),
            Treatment(category: "Soil Health", description: "Reduce overhead watering immediately. Switch to drip irrigation and water at the base only during early morning hours."),
            Treatment(category: "Follow-Up Scan", description: "Re-scan in 10 days. Powdery mildew is cosmetic at this stage but can reduce yield if left untreated beyond 3 weeks.")
        ]
    ),
    DiseaseProfile(
        plantName: "Basil",
        diseaseName: nil,
        healthScore: 0.95,
        treatments: [
            Treatment(category: "Chemical Control", description: "No chemical treatment needed. Consider a preventative neem oil spray every 2 weeks during humid seasons."),
            Treatment(category: "Pruning", description: "Pinch growing tips regularly to encourage bushy growth. Harvest from the top down to maintain plant vigor."),
            Treatment(category: "Soil Health", description: "Maintain slightly acidic soil pH (6.0-7.0). Top-dress with worm castings monthly for sustained nutrient release."),
            Treatment(category: "Follow-Up Scan", description: "Routine scan recommended in 30 days. Your plant is in excellent health with no signs of disease or pest damage.")
        ]
    )
]

// MARK: - CameraViewModel

@MainActor
final class CameraViewModel: ObservableObject {

    // MARK: Published State

    @Published var selectedImage: UIImage?
    @Published var isAnalyzing: Bool = false
    @Published var scanResult: ScanResultData?
    @Published var showResult: Bool = false

    @Published var photoPickerItem: PhotosPickerItem?

    // MARK: - Photo Selection

    func handlePickerSelection(_ item: PhotosPickerItem?) async {
        guard let item else {
            return
        }
        if let data = try? await item.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
            selectedImage = uiImage
        }
    }

    // MARK: - Load Sample Image

    func loadSampleImage() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 400))
        let sampleImage = renderer.image { context in
            UIColor.systemGreen.withAlphaComponent(0.2).setFill()
            context.fill(CGRect(x: 0, y: 0, width: 400, height: 400))

            UIColor.systemGreen.setFill()
            let leafPath = UIBezierPath(ovalIn: CGRect(x: 80, y: 60, width: 240, height: 300))
            leafPath.fill()

            UIColor.green.withAlphaComponent(0.6).setFill()
            let veinPath = UIBezierPath(rect: CGRect(x: 195, y: 60, width: 10, height: 300))
            veinPath.fill()

            UIColor.brown.withAlphaComponent(0.4).setFill()
            let spotPath1 = UIBezierPath(ovalIn: CGRect(x: 140, y: 160, width: 40, height: 40))
            spotPath1.fill()
            let spotPath2 = UIBezierPath(ovalIn: CGRect(x: 230, y: 220, width: 30, height: 30))
            spotPath2.fill()
        }
        selectedImage = sampleImage
    }

    // MARK: - Analyze Image

    func analyzeImage() {
        guard selectedImage != nil else { return }
        isAnalyzing = true
        scanResult = nil

        Task {
            try? await Task.sleep(for: .seconds(2))
            let profile = mockDiseaseProfiles.randomElement() ?? mockDiseaseProfiles[0]
            let result = ScanResultData(
                plantName: profile.plantName,
                diseaseName: profile.diseaseName,
                healthScore: profile.healthScore,
                treatments: profile.treatments,
                scanDate: Date()
            )
            isAnalyzing = false
            scanResult = result
            showResult = true
        }
    }

    // MARK: - Reset

    func reset() {
        selectedImage = nil
        scanResult = nil
        showResult = false
        isAnalyzing = false
        photoPickerItem = nil
    }
}
