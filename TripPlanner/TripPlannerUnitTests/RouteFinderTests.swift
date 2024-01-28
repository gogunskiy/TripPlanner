import XCTest
@testable import TripPlanner

final class RouteFinderTests: XCTestCase {
    func testFindRoute() throws {
        let coordinates = Coordinates(from: Coordinate(lat: 0, long: 0), to: Coordinate(lat: 1, long: 1))
        let connections = [
            Connection(from: "CityA", to: "CityB", price: 100, coordinates: coordinates),
            Connection(from: "CityB", to: "CityA", price: 100, coordinates: coordinates),
            Connection(from: "CityB", to: "CityC", price: 100, coordinates: coordinates),
            Connection(from: "CityC", to: "CityB", price: 100, coordinates: coordinates),
        ]
        
        let routeFinder = RouteFinder()
        let route = try XCTUnwrap(routeFinder.findCheapestRoute(from: "CityA", to: "CityC", connectionsData: ConnectionsData(connections: connections)))

        XCTAssertEqual(route.destinations, ["CityA", "CityB", "CityC"])
    }
}
