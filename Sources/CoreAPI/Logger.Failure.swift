import Foundation

extension Logger {
    enum Failure {
        case decoding (model: Decodable.Type, error: Swift.Error, path: String)
    }
}
