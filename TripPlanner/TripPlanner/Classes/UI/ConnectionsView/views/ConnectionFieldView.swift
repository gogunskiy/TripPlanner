import SwiftUI

struct ConnectionFieldView: View {
    @StateObject var viewModel: ConnectionFieldViewModel
    
    var body: some View {
        TextField(viewModel.placeHolder, text: $viewModel.searchTerm)
            .padding()
            .font(.title)
            .background(Color.appBlack)
            .cornerRadius(8)
            .foregroundColor(.white)
    }
}
