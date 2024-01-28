import XCTest
@testable import TripPlanner
import Combine

final class ConnectionsViewModelTests: XCTestCase {
    private let viewModel = ConnectionsViewModel(networkAgent: MockNetworkAgent())
    private var cancellables: Set<AnyCancellable> = []

    func testInitialValues() {
        XCTAssertTrue(viewModel.isEmpty)
        XCTAssertEqual(viewModel.title, "Connections")
        XCTAssertEqual(viewModel.departureCityFieldViewModel.placeHolder, "Departure")
        XCTAssertEqual(viewModel.destinationCityFieldViewModel.placeHolder, "Destination")
        XCTAssertEqual(viewModel.connectionSearchButtonViewModel.title, "Search Route")
    }
    
    func testFetchData() {
        let expection = XCTestExpectation(description: "fetch data")
        
        fetchData { expection.fulfill() }
        
        wait(for: [expection], timeout: 1.0)

    }
    
    func testRouteFound() {
        let expection = XCTestExpectation(description: "find route")
        
        fetchData { [weak self] in
            self?.findRoute(from: "London", to: "Los Angeles") { path in
                XCTAssertEqual(path, "Route: London->New York->Los Angeles")
                expection.fulfill()
            }
        }

        wait(for: [expection], timeout: 1.0)
    }
    
    func testRouteNotFound() {
        let expection = XCTestExpectation(description: "find route")
        
        fetchData { [weak self] in
            self?.findRoute(from: "London", to: "Los") { path in
                XCTAssertEqual(path, "")
                expection.fulfill()
            }
        }

        wait(for: [expection], timeout: 1.0)
    }
    
    func testRouteToTheSameCity() {
        let expection = XCTestExpectation(description: "find route")
        
        fetchData { [weak self] in
            self?.findRoute(from: "London", to: "London") { path in
                XCTAssertEqual(path, "Route: London")
                expection.fulfill()
            }
        }

        wait(for: [expection], timeout: 1.0)
    }
    
    private func fetchData(completion: @escaping () -> ()) {
        viewModel.fetchConnections()
        viewModel.$isEmpty.sink { value in
            if !value { completion() }
        }.store(in: &cancellables)
    }
    
    private func findRoute(from: String, to: String, completion: @escaping (String) -> ()) {
        viewModel.departureCityFieldViewModel.searchTerm = from
        viewModel.destinationCityFieldViewModel.searchTerm = to
        viewModel.findCheapestConnection()
        viewModel.connectionResultsViewModel.$path.sink { path in
            completion(path)
        }.store(in: &self.cancellables)
    }
}
