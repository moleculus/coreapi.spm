import Foundation

public enum Result<SuccessResponse: Decodable, FailureResponse: Decodable> {
    case success (SuccessResponse)
    case failure (Error<FailureResponse>)
}
