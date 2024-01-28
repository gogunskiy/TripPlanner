import Foundation
import Combine
import MapKit

final class ConnectionResultsViewModel: ObservableObject {
    enum ConnectionResultsErrorViewModel {
        case none
        case routeNotFound
        
        var title: String {
            return "Error"
        }
        
        var message: String {
            switch self {
            case .routeNotFound:
                return "The route has not been found. Please, try again."
            case .none:
                return ""
            }
        }
    }
    
    
    @Published var path = ""
    @Published var price = ""
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var annotations = [MapViewAnnotation]()
    @Published var errorViewModel : ConnectionResultsErrorViewModel = .none
    
    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        return formatter
    }()
    
    func update(with route: Route) {
        self.path = "Route: \(route.destinations.joined(separator: "->"))"
        if let formattedPrice = numberFormatter.string(from: route.totalPrice as NSNumber) {
            self.price = "Total Price: \(formattedPrice)"
        } else {
            self.price = "\(route.totalPrice)"
        }
    }
    
    func update(with mapData: MapViewData) {
        self.region = mapData.region
        self.annotations = mapData.annotations
    }
    
    func clearAll() {
        self.price = ""
        self.path = ""
        self.errorViewModel = .none
        self.region = MKCoordinateRegion()
        self.annotations = []
    }
}
