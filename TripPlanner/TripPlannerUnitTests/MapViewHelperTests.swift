import XCTest
@testable import TripPlanner

final class MapViewHelperTests: XCTestCase {
    func testExtractMapViewData() {
        let coordinates = Coordinates(from: Coordinate(lat: 0, long: 0), to: Coordinate(lat: 1, long: 1))
        let connections = [
            Connection(from: "CityA", to: "CityB", price: 100, coordinates: coordinates),
            Connection(from: "CityB", to: "CityC", price: 100, coordinates: coordinates),
        ]
        let mockConnectionsData = ConnectionsData(connections: connections)
        let mockRoute = ["CityA", "CityB", "CityC"]
        
        let mapViewData = MapViewHelper().extractMapViewData(from: mockConnectionsData, route: mockRoute)
        
        XCTAssertNotNil(mapViewData)
        XCTAssertEqual(mapViewData.annotations.count, mockRoute.count)
    }
}
