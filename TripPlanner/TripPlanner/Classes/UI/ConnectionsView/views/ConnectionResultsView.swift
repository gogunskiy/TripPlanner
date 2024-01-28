import SwiftUI
import MapKit

struct ConnectionResultsView: View {
    @StateObject var viewModel: ConnectionResultsViewModel
    @State var region = MKCoordinateRegion()
    @State var showError: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.path)
                .font(.headline)
                .foregroundColor(.green)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.black))
                .padding(.horizontal, 16)
            
            Text(viewModel.price)
                .font(.headline)
                .foregroundColor(.green)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.black))
                .padding(.horizontal, 16)
            
            Map(coordinateRegion: $region, annotationItems: viewModel.annotations) { annotation in
                MapPin(coordinate: annotation.coordinate)
            }
            .onReceive(viewModel.$region, perform: { region in
                self.region = region
            })
            .onReceive(viewModel.$errorViewModel, perform: { viewModel in
                self.showError = viewModel != .none
            })
            .frame(maxWidth: .infinity, maxHeight: 200)
                .cornerRadius(8)
        }.alert(viewModel.errorViewModel.title, isPresented: $showError, actions: {
        }, message: {
            Text(viewModel.errorViewModel.message)
        })
    }
}

