//
//  RouteFinder.swift
//  TripPlanner
//
//  Created by vgogunsky on 25.01.2024.
//

import Foundation

struct Route {
    var destinations: [String] = []
    var totalPrice: Double = 0.0
}

/// 
/// The helper class that allows to build a trip path based on departure and destination
/// Dijkstra's algorithm is used to build the path and calculate the total price.
/// Complexity: O(N^2)
/// Returns `Route`  data.
///
struct RouteFinder {
    func findCheapestRoute(from: String, to: String, connectionsData: ConnectionsData) -> Route? {
        var costs: [String: Double] = [:]
        var parents: [String: String] = [:]
        var visitedCities: Set<String> = []

        // Initializes costs for all cities except the start city
        for connection in connectionsData.connections {
            costs[connection.from] = (connection.from == from) ? 0 : Double.infinity
        }

        while !visitedCities.contains(to) {
            // Finds the city with the lowest cost that has not been visited
            let currentCity = costs.filter { !visitedCities.contains($0.key) }.min { $0.value < $1.value }?.key

            guard let current = currentCity else {
                return nil
            }

            // Marks the current city as visited
            visitedCities.insert(current)

            // Updates costs and parents for neighboring cities
            for connection in connectionsFrom(city: current, connectionsData: connectionsData) {
                let totalCost = costs[current] ?? 0.0 + connection.price

                if totalCost < costs[connection.to] ?? 0.0 {
                    costs[connection.to] = totalCost
                    parents[connection.to] = current
                }
            }
        }

        var route: [String] = [to]
        var current = to

        while current != from, let parent = parents[current] {
            route.insert(parent, at: 0)
            current = parent
        }

        // If the start and end cities are not connected, returns nil
        if route.first != from {
            return nil
        }

        return Route(destinations: route, totalPrice: costs[to] ?? 0.0)
    }
        
    private func connectionsFrom(city: String, connectionsData: ConnectionsData) -> [Connection] {
        return connectionsData.connections.filter { $0.from == city }
    }
}
