import Foundation
import Combine

enum Request: NetworkRequest {
    case connections
    
    var requestURL: URL? {
        switch self {
        case .connections:
            return URL(string: "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json")
        }
    }
}

class NetworkAgent: NetworkAgentProtocol {
    func fetchData<Data>(_ request: NetworkRequest) -> AnyPublisher<Data, Error> where Data : Decodable {
        guard let url = request.requestURL else {
            return Fail(error: NetworkError.malformedURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Data.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
