
import Foundation
import Alamofire
import SystemConfiguration
import SVProgressHUD

typealias CompletionBlock = (ResponseObject?, Error?) -> Void

class APIClient {
   // var interceptor: RequestInterceptor? = nil
    var interceptor: RequestInterceptor? = nil
    static let sharedInstance = APIClient()
   
    func handlerResponseData(callback: (Data?, Error?)) {
        
    }
    
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaulRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { (zeroSockAddress) in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaulRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func request<Request>(baseUrl: String = kBaseServer, request: Request, showLoading: Bool = true, callback: @escaping CompletionBlock) where Request : NetworkRequest {
        if !APIClient.isInternetAvailable() {
            let errorTemp = NSError(domain: "", code: 10000, userInfo: nil)
            callback(ResponseObject(), errorTemp as Error)
            return
        }
        let method = HTTPMethod(rawValue: request.method.uppercased())
        let url = baseUrl + request.path
        var parameters: [String: Any]? = request.parameters
        var encoding: ParameterEncoding = URLEncoding.default
        if let body = request.body, let data = body.data as? [String: Any], body.encoding == NetworkUtil.JSON_ENCODING {
            parameters = data
            encoding = JSONEncoding.default
        }
        var headers: HTTPHeaders?
        if let h = request.headers {
            
            headers = HTTPHeaders(h)
        }
        print("Param: ", parameters ?? (Any).self)
        print("header: ", headers ?? (Any).self)
        if showLoading && !SVProgressHUD.isVisible() {
            SVProgressHUD.show()
        }
        AF.session.configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: self.interceptor).responseData { [weak self] (response) in
            self?.processResponse(response: response, callBack: callback)
        }
    }
    
    func processResponse(response: AFDataResponse<Data>, callBack: @escaping CompletionBlock) {
        SVProgressHUD.dismiss()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        switch response.result {
        case .success(let data):
            debugPrint("data: \(data)")
            let responseObject = ResponseObject()
            responseObject.data = response.data
            responseObject.httpCode = (response.response?.statusCode)!
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8){
                let respon = response.description
                print("URL: \(response.request?.url?.absoluteString ?? "")" )
                print("Description: \(respon)")
                print("Data: \(utf8Text)")
                responseObject.jsonString = utf8Text
                
                if let tempDict = convertToDictionary(text: utf8Text){
                    responseObject.message = tempDict["error_description"] as? String
                } else {
                    responseObject.message = "Fail"
                }
                if response.response?.statusCode == 200 {
                    responseObject.errorCode = 0
                }else if response.response?.statusCode == 401 {
                    return
                }else{
                    responseObject.errorCode = -1
                   
                }
            }
            callBack(responseObject,nil)
        case .failure(let error):
            if let underlyingError = error.underlyingError {
                if let urlError = underlyingError as? URLError {
                    switch urlError.code {
                    case .timedOut,.notConnectedToInternet,.networkConnectionLost: break
                        
                    default:
                        print("Unmanaged error")
                    }
                }
            }
            
            callBack(ResponseObject(),error)
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8){
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            } catch {
                print(error.localizedDescription)
            }
            
        }
        return nil
    }
    
    func getHeader() -> HTTPHeaders{
        var parameters: HTTPHeaders
        parameters = ["Content-Type":"application/json",
                      "Accept":"application/json"] as HTTPHeaders? ?? HTTPHeaders()
        return parameters
    }
    
   
}
