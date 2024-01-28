import Foundation
import Combine

final class ConnectionFieldViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var placeHolder: String = ""

    init(searchTerm: String, placeHolder: String) {
        self.searchTerm = searchTerm
        self.placeHolder = placeHolder
    }
}

