import Foundation
import Alamofire

struct Logger {
    
    // MARK: - Properties.
    
    private let isEnabled = true
    
    // MARK: - Public Methods.
    
    func log(_ failure: Failure) {
        guard isEnabled else { return }
        
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
    
    func log<R: Request>(request: R, dataRequest: DataRequest) {
        dataRequest.responseJSON {
            print("\n===")
            print(dataRequest.request?.headers as Any)
            print(request.path)
            print(request.nonNilParameters as Any)
            print("---")
            print($0.result)
            print("===\n")
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
