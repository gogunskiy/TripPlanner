import SwiftUI

struct ConnectionsView: View {
    @StateObject var viewModel: ConnectionsViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                if viewModel.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.appGray))
                        .frame(maxWidth: .infinity)
                }
                
                ConnectionFieldView(viewModel: viewModel.departureCityFieldViewModel)
                ConnectionFieldView(viewModel: viewModel.destinationCityFieldViewModel)
                ConnectionSearchButtonView(viewModel: viewModel.connectionSearchButtonViewModel) {
                    viewModel.findCheapestConnection()
                }
                ConnectionResultsView(viewModel: viewModel.connectionResultsViewModel)
                Spacer()
            }
            .padding()
            .frame(maxWidth: 500)
            .navigationBarTitle(viewModel.title, displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            viewModel.fetchConnections()
        }
    }
}
