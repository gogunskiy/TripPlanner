import Foundation
import Combine

protocol NetworkRequest {
    var requestURL: URL? { get }
}

enum NetworkError: Error {
    case malformedURL
}

protocol NetworkAgentProtocol {
    func fetchData<Data: Decodable>(_ request: NetworkRequest) -> AnyPublisher <Data, Error>
}

#if DEBUG
enum DebugError: Error {
    case mockIsNotAvailable
}

final class MockNetworkAgent: NetworkAgentProtocol {
    private var mocksMap = ["connections.json" : "connections"]
    
    func fetchData<Data>(_ request: NetworkRequest) -> AnyPublisher<Data, Error> where Data : Decodable {
        guard let lastPathComponent = request.requestURL?.lastPathComponent else {
            return Fail(error: NetworkError.malformedURL).eraseToAnyPublisher()
        }
        
        guard let mock = mocksMap[lastPathComponent],
              let resourceURL =  Bundle(for: type(of: self)).url(forResource: mock, withExtension: "json") else {
            return Fail(error: DebugError.mockIsNotAvailable).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: resourceURL)
            .map(\.data)
            .decode(type: Data.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

#endif
