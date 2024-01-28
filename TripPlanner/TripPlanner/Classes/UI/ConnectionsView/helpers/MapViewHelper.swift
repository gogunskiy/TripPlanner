//
//  MapViewHelper.swift
//  TripPlanner
//
//  Created by vgogunsky on 25.01.2024.
//

import MapKit

struct MapViewAnnotation: Identifiable, Hashable {
    static func == (lhs: MapViewAnnotation, rhs: MapViewAnnotation) -> Bool {
        return lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    var id = UUID()
    var title: String
    var coordinate: CLLocationCoordinate2D
}

struct MapViewData {
    let region: MKCoordinateRegion
    let annotations: [MapViewAnnotation]
}

/// 
/// The helper class that allows to calculate map view attributes:
/// Returns `MapViewData`.
/// 
struct MapViewHelper {
    func extractMapViewData(from connectionsData: ConnectionsData, route: [String]) -> MapViewData {
        let annotations = route.reduce(into: Set<MapViewAnnotation>(), { data, element in
            if let connection = connectionsData.connections.first(where: { $0.from == element }) {
                let coordinate = CLLocationCoordinate2D(latitude: connection.coordinates.from.lat, longitude: connection.coordinates.from.long)
                data.insert(MapViewAnnotation(title: element, coordinate: coordinate))
            }
            
            if let connection = connectionsData.connections.first(where: { $0.to == element }) {
                let coordinate = CLLocationCoordinate2D(latitude: connection.coordinates.to.lat, longitude: connection.coordinates.to.long)
                data.insert(MapViewAnnotation(title: element, coordinate: coordinate))
            }
        })

        return MapViewData(region: region(from: annotations), annotations: Array(annotations))
    }
    
    private func region(from annotations: Set<MapViewAnnotation>) -> MKCoordinateRegion {
        let allLats = annotations.map { $0.coordinate.latitude }
        let allLongs = annotations.map { $0.coordinate.longitude }

        let minLat: CLLocationDegrees = allLats.min() ?? 0.0
        let maxLat: CLLocationDegrees = allLats.max() ?? 0.0
        let minLon: CLLocationDegrees = allLongs.min() ?? 0.0
        let maxLon: CLLocationDegrees = allLongs.max() ?? 0.0

        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)
        let center =  CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2)
        return MKCoordinateRegion(center: center, span: span)
    }
}
