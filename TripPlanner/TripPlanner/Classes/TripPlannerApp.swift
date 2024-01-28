import SwiftUI

@main
struct TripPlannerApp: App {
    var body: some Scene {
        WindowGroup {
            ConnectionsView(viewModel: ConnectionsViewModel(networkAgent: NetworkAgent()))
        }
    }
}
