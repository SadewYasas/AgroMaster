import Foundation
import CoreLocation
import MapKit

// MARK: - Support Center Model

struct SupportCenter: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    let distance: String
    let categories: [String]
    let phone: String?
    let icon: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Location View Model

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: - Published Properties

    @Published var supportCenters: [SupportCenter] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
    )
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var selectedCenter: SupportCenter?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = true

    // MARK: - Private Properties

    private let locationManager = CLLocationManager()
    private var hasReceivedInitialLocation = false

    // MARK: - Computed Properties

    var filteredCenters: [SupportCenter] {
        if searchText.isEmpty {
            return supportCenters
        }
        let query = searchText.lowercased()
        return supportCenters.filter { center in
            center.name.lowercased().contains(query)
            || center.categories.contains { $0.lowercased().contains(query) }
        }
    }

    // MARK: - Initialization

    override init() {
        super.init()
        loadSupportCenters()
        setupLocationManager()
    }

    // MARK: - Location Manager Setup

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate = location.coordinate

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.userLocation = coordinate

            if !self.hasReceivedInitialLocation {
                self.hasReceivedInitialLocation = true
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
                )
                self.isLoading = false
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            isLoading = false
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
    }

    // MARK: - Distance Calculation

    func distanceFromUser(to center: SupportCenter) -> String {
        guard let userLocation else {
            return center.distance
        }
        let userCL = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let centerCL = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let distanceInMeters = userCL.distance(from: centerCL)
        let distanceInKm = distanceInMeters / 1000.0

        if distanceInKm < 1.0 {
            let meters = Int(distanceInMeters)
            return "\(meters) m"
        } else {
            return String(format: "%.1f km", distanceInKm)
        }
    }

    // MARK: - Hardcoded Support Centers

    private func loadSupportCenters() {
        supportCenters = [
            SupportCenter(
                name: "GreenLeaf Agro Center",
                description: "Your one-stop shop for premium agricultural supplies, organic pesticides, and expert pest management consultations for all crop types.",
                latitude: 6.9175,
                longitude: 79.8613,
                distance: "1.1 km",
                categories: ["Retail", "Pest Management"],
                phone: "+94 11 234 5678",
                icon: "leaf.circle.fill"
            ),
            SupportCenter(
                name: "FarmCare Hub",
                description: "Professional soil testing laboratory and fertilizer advisory service. Get detailed soil reports and customized nutrient plans for your farm.",
                latitude: 6.9350,
                longitude: 79.8500,
                distance: "1.5 km",
                categories: ["Soil Testing", "Fertilizers"],
                phone: "+94 11 345 6789",
                icon: "flask.fill"
            ),
            SupportCenter(
                name: "Lanka Seeds & Nursery",
                description: "Wide selection of certified seeds, seedlings, and ornamental plants. Specializing in tropical fruit trees and vegetable starter kits.",
                latitude: 6.9100,
                longitude: 79.8700,
                distance: "2.2 km",
                categories: ["Seeds", "Nursery"],
                phone: "+94 11 456 7890",
                icon: "camera.macro"
            ),
            SupportCenter(
                name: "AgriTech Solutions",
                description: "Modern farming equipment, drone spraying services, and precision agriculture technology to maximize your yield and reduce labor costs.",
                latitude: 6.9400,
                longitude: 79.8650,
                distance: "1.8 km",
                categories: ["Equipment", "Technology"],
                phone: "+94 11 567 8901",
                icon: "gearshape.2.fill"
            ),
            SupportCenter(
                name: "CropGuard Pest Services",
                description: "Integrated pest management specialists offering field inspections, biological control solutions, and ongoing crop protection consulting.",
                latitude: 6.9250,
                longitude: 79.8550,
                distance: "0.9 km",
                categories: ["Pest Management", "Consulting"],
                phone: nil,
                icon: "shield.checkered"
            )
        ]
    }
}
