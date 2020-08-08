import Foundation
import Alamofire

public protocol APIService {
    var baseURL: String { get }
    var headers: HTTP.Headers { get }
    var errorHandler: ErrorHandling { get }
    var jsonDecoder: JSONDecoder { get }
}

extension APIService {
    
    // MARK: - Public Methods.
    
    @discardableResult
    public func send<R: Request>(request: R, isAPILogginEnabled: Bool = false, then completion: ((_ result: Result<R.SuccessResponse, R.FailureResponse>) -> Void)?) -> DataRequest {
        let requestURL = baseURL + request.path
        let httpMethod = HTTPMethod(method: request.method)
        let dataRequest = AF.request(requestURL, method: httpMethod, parameters: request.nonNilParameters, encoding: request.encoding, headers: headers)
        
        dataRequest.responseData {
            let result = self.handle(dataResponse: $0, for: request)
            
            if case .failure (let error) = result {
                self.errorHandler.handleError(error, in: request)
            }
            
            completion?(result)
        }
        
        if isAPILogginEnabled {
            Logger().log(request: request, dataRequest: dataRequest)
        }
            
        return dataRequest
    }
    
    public func upload<R: Request>(request: R, then completion: @escaping (_ uploadRequest: UploadRequest?, _ result: Result<R.SuccessResponse, R.FailureResponse>?, _ uploadProgress: Double) -> Void) {
        let requestURL = baseURL + request.path
        let httpMethod = HTTPMethod(method: request.method)
        let multipartFormData = self.multipartFormData(for: request)
        let uploadRequest = AF.upload(multipartFormData: multipartFormData, to: requestURL, method: httpMethod, headers: headers, interceptor: nil, fileManager: .default)
        
        uploadRequest.uploadProgress { (progress) in
            completion(uploadRequest, nil, progress.fractionCompleted)
        }
        
        uploadRequest.responseData {
            let result = self.handle(dataResponse: $0, for: request)
            
            if case .failure (let error) = result {
                self.errorHandler.handleError(error, in: request)
            }
                        
            completion(uploadRequest, result, 1)
        }
    }
    
    // MARK: - Private Methods.
    
    private func handle<R: Request>(dataResponse: AFDataResponse<Data>, for request: R) -> Result<R.SuccessResponse, R.FailureResponse> {
        guard let response = decode(R.SuccessResponse.self, from: dataResponse.data, for: request) else {
            let error = Error<R.FailureResponse>(httpCode: dataResponse.response?.statusCode, data: dataResponse.data)
            return .failure(error)
        }
        
        return .success(response)
    }
    
    private func decode<T: Decodable, R: Request>(_ type: T.Type, from data: Data?, for request: R) -> T? {
        guard let data = data else {
            return nil
        }
        
        do {
            let response = try jsonDecoder.decode(T.self, from: data)
            return response
        }
        catch (let error) {
            Logger().log(.decoding(model: T.self, error: error, path: request.path))
            return nil
        }
    }
    
    private func multipartFormData<R: Request>(for request: R) -> MultipartFormData {
        let multipartFormData = MultipartFormData()
        
        guard let parameters = request.nonNilParameters else {
            return multipartFormData
        }
        
        for key in parameters.keys {
            guard let parameter = MultipartDataItem(parameters[key]) else {
                assertionFailure("APIRequesting: Failed to init APIParameter")
                continue
            }
            
            guard let data = parameter.data else {
                assertionFailure("APIRequesting: Failed to init Data")
                continue
            }
            
            switch parameter {
            case .image:
                multipartFormData.append(data, withName: key, fileName: "image.jpg", mimeType: "image/jpeg")
            case .string:
                multipartFormData.append(data, withName: key)
            }
        }
        
        return multipartFormData
    }
    
}
