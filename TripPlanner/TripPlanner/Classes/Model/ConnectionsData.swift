import Foundation

struct ConnectionsData: Codable {
    var connections: [Connection]
}

struct Connection: Codable, Hashable {
    static func == (lhs: Connection, rhs: Connection) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to
    }
    
    let from: String
    let to: String
    let price: Double
    let coordinates: Coordinates
}

struct Coordinates: Codable, Hashable {
    let from: Coordinate
    let to: Coordinate
}

struct Coordinate: Codable, Hashable {
    let lat: Double
    let long: Double
}
