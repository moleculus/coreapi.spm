import Alamofire

public protocol Request {
    associatedtype SuccessResponse: Decodable
    associatedtype FailureResponse: Decodable
        
    var method: HTTP.Method { get }
    var path: String { get }
    var parameters: [String: Any?] { get }
}

extension Request {
    var nonNilParameters: [String: Any]? {
        let parameters = self.parameters.compactMapValues { $0 }
        
        if parameters.keys.isEmpty {
            return nil
        }
        else {
            return parameters
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
