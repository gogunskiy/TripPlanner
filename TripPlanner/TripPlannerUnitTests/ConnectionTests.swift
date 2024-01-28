import XCTest
@testable import TripPlanner

final class ConnectionTests: XCTestCase {
    func testFindRoute() {
        let coordinates =  Coordinates(from: Coordinate(lat: 0, long: 0),
                                       to: Coordinate(lat: 0, long: 0))
        let connection1 = Connection(from: "A",
                                     to: "B",
                                     price: 100,
                                     coordinates: coordinates)
        
        let connection2 = Connection(from: "A",
                                     to: "B",
                                     price: 100,
                                     coordinates: coordinates)
        
        XCTAssertEqual(connection1, connection2)
    }
}
