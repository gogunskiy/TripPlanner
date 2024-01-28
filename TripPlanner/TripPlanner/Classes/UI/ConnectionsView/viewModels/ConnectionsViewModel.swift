import Foundation
import Combine

final class ConnectionsViewModel: ObservableObject {
    let departureCityFieldViewModel = ConnectionFieldViewModel(searchTerm: "London",
                                                               placeHolder: "Departure")
    let destinationCityFieldViewModel = ConnectionFieldViewModel(searchTerm: "Los Angeles",
                                                                 placeHolder: "Destination")
    let connectionSearchButtonViewModel = ConnectionSearchButtonViewModel()
    let connectionResultsViewModel = ConnectionResultsViewModel()
    
    @Published var isEmpty = true
    var title = "Connections"

    private var networkAgent: NetworkAgentProtocol
    private var routeFinder = RouteFinder()
    private var mapViewHelper = MapViewHelper()
    private var connectionsData: ConnectionsData?
    private var cancellables: Set<AnyCancellable> = []
   
    init(networkAgent: NetworkAgentProtocol) {
        self.networkAgent = networkAgent
    }
    
    func fetchConnections() {
        networkAgent.fetchData(Request.connections).sink { _ in
        } receiveValue: { [weak self] (connectionsData: ConnectionsData) in
            self?.handleConnectionsResponse(connectionsData)
        }.store(in: &cancellables)
    }
    
    func findCheapestConnection() {
        guard let connectionsData = connectionsData,
              let cheapestRoute = routeFinder.findCheapestRoute(from: departureCityFieldViewModel.searchTerm,
                                                                to: destinationCityFieldViewModel.searchTerm,
                                                                connectionsData: connectionsData) else {
            self.connectionResultsViewModel.clearAll()
            self.connectionResultsViewModel.errorViewModel = .routeNotFound
            return
        }
       
        self.connectionResultsViewModel.update(with: cheapestRoute)
        
        let mapData = MapViewHelper().extractMapViewData(from: connectionsData, route: cheapestRoute.destinations)
        self.connectionResultsViewModel.update(with: mapData)
    }
    
    private func handleConnectionsResponse(_ connectionsData: ConnectionsData) {
        self.connectionsData = connectionsData
        self.isEmpty = connectionsData.connections.isEmpty
    }
}
