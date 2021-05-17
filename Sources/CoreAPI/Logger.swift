import Foundation
import Alamofire

public struct Logger {
    
    // MARK: - Public Methods.
    
    func log(_ failure: Failure) {
        switch failure {
        case .decoding (let model, let error, let path):
            print("\n------\n")
            print(model)
            print(path)
            print("\n---\n")
            print(error)
            print("\n------\n")
        }
    }
    
    func log<R: Request>(request: R, dataRequest: DataRequest, start: Date, depth: Depth) {
        dataRequest.responseJSON {
            switch depth {
            case .off:
                break
            case .path:
                print("\n===")
                print("Executed in (seconds) = ", Date().timeIntervalSince1970 - start.timeIntervalSince1970)
                print((dataRequest.request?.httpMethod?.description ?? "") + ": " + request.path)
                print("===\n")
            case .full:
                print("\n===")
                print("Executed in (seconds) = ", Date().timeIntervalSince1970 - start.timeIntervalSince1970)
                print(dataRequest.request?.headers as Any)
                print((dataRequest.request?.httpMethod?.description ?? "") + ": " + request.path)
                print(request.nonNilParameters as Any)
                print("---")
                print($0.result)
                print("===\n")
            }
        }
    }
    
    func log<R: Request>(request: R, uploadRequest: UploadRequest) {
        uploadRequest.responseJSON {
            print("\n===")
            print(request.path)
            print(uploadRequest.request?.headers as Any)
            print(request.nonNilParameters as Any)
            print("---")
            print($0.result)
            print("===\n")
        }
    }
    
}

extension Logger {
    public enum Depth {
        case off
        case path
        case full
    }
}
