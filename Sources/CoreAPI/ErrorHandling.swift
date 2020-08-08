import Foundation
import Alamofire

public protocol ErrorHandling {
    func handleError<R: Request>(_ error: Error<R.FailureResponse>, in _: R)
}
