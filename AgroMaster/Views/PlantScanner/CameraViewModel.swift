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
            Treatment(category: "Foliar Application", description: "Apply chlorothalonil or copper-based fungicide every 7-10 days. Ensure thorough leaf coverage, especially on the lower canopy where lesions first appear."),
            Treatment(category: "Sanitation", description: "Remove and destroy all infected lower leaves immediately. Bag debris rather than composting to prevent reinfection through windborne spores."),
            Treatment(category: "Soil Nutrition", description: "Top-dress with a calcium-rich compost and balanced fertilizer to bolster cell wall strength. Apply a 2-inch organic mulch layer to suppress soil splash."),
            Treatment(category: "Irrigation Adjustment", description: "Switch to drip irrigation at the base of the plant and avoid wetting foliage. Water early in the morning so leaves dry quickly during the day."),
            Treatment(category: "Future Monitoring", description: "Re-scan every 5-7 days to track lesion spread. If the health score drops below 30%, consider removing the plant to protect neighboring crops.")
        ]
    ),
    DiseaseProfile(
        plantName: "Rose",
        diseaseName: "Leaf Spot",
        healthScore: 0.614,
        treatments: [
            Treatment(category: "Foliar Application", description: "Treat with neem oil spray (2 tbsp per gallon) weekly, alternating with a baking soda solution to prevent fungal resistance and protect new growth."),
            Treatment(category: "Sanitation", description: "Cut affected leaves at the stem junction and rake up fallen debris around the base. Sanitize pruning shears with 70% isopropyl alcohol between each cut."),
            Treatment(category: "Soil Nutrition", description: "Apply a balanced 10-10-10 fertilizer with added micronutrients to strengthen the plant's immune response. Mulch with composted bark to retain moisture."),
            Treatment(category: "Irrigation Adjustment", description: "Water at the soil line in the morning hours and avoid overhead sprinklers entirely. Improve drainage around the root zone to prevent standing moisture."),
            Treatment(category: "Future Monitoring", description: "Inspect weekly for three weeks. Leaf spot typically resolves within 14-21 days with consistent treatment, but recurrence is common in humid conditions.")
        ]
    ),
    DiseaseProfile(
        plantName: "Cucumber",
        diseaseName: "Powdery Mildew",
        healthScore: 0.736,
        treatments: [
            Treatment(category: "Foliar Application", description: "Apply sulfur-based fungicide or a potassium bicarbonate solution to coated leaves. Spray in the early morning when temperatures stay below 90F to avoid leaf burn."),
            Treatment(category: "Sanitation", description: "Remove the most heavily coated leaves first and dispose of them off-site. Thin dense foliage to increase sunlight penetration and reduce humidity pockets."),
            Treatment(category: "Soil Nutrition", description: "Side-dress with compost and a low-nitrogen fertilizer to avoid encouraging soft, susceptible new growth. Add silica to reinforce leaf surfaces."),
            Treatment(category: "Irrigation Adjustment", description: "Stop overhead watering immediately and switch to drip irrigation at the base. Water early so any incidental leaf moisture evaporates well before nightfall."),
            Treatment(category: "Future Monitoring", description: "Re-scan in 10 days to gauge spread. Powdery mildew is cosmetic at this stage but can significantly reduce yield if left untreated beyond three weeks.")
        ]
    ),
    DiseaseProfile(
        plantName: "Basil",
        diseaseName: nil,
        healthScore: 0.95,
        treatments: [
            Treatment(category: "Foliar Application", description: "No active treatment is needed. Consider a preventative neem oil mist every 2 weeks during humid seasons to deter pests and early fungal pressure."),
            Treatment(category: "Sanitation", description: "Pinch growing tips regularly to encourage bushy growth and remove any yellowing leaves promptly. Harvest from the top down to maintain plant vigor."),
            Treatment(category: "Soil Nutrition", description: "Maintain a slightly acidic soil pH (6.0-7.0). Top-dress with worm castings monthly for sustained, gentle nutrient release that supports flavor development."),
            Treatment(category: "Irrigation Adjustment", description: "Water deeply when the top inch of soil feels dry and avoid letting the plant wilt between waterings. Morning watering keeps foliage dry through the day."),
            Treatment(category: "Future Monitoring", description: "Schedule a routine scan in 30 days to maintain baseline health. Your plant is in excellent condition with no signs of disease or pest damage at this time.")
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
