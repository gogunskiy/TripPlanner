import SwiftUI

struct ConnectionSearchButtonView: View {
    @StateObject var viewModel: ConnectionSearchButtonViewModel
    var action: () -> ()
    
    var body: some View {
        Button(viewModel.title) { action() }
            .font(.title)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.appBlue)
            .cornerRadius(8)
    }
}
