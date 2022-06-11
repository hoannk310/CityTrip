struct NetworkUtil {
    static let AUTHORIZATION = "authorization"
    static let ACCEPT_LANGUAGE = "Accept-Language"
    static let ACCEPT_LANGUAGE_VALUE = "ACCEPT_LANGUAGE"
    static let TOKEN_TYPE = "Bearer"
    static let JSON_ENCODING: String = "json"
    static let MULTIPART_FORM = "multipart_form"
    static let ACCESS_TOKEN = "access-token"
    static let APP_ID = "app-id"
    static let APP_ID_VALUE = "skyid-service"
}

protocol BodyRequest {
    var data: Any { get }
    var encoding: String { get }
}

struct DefaultBodyRequest: BodyRequest {
    var data: Any
    
    var encoding: String
}

protocol NetworkRequest {
    var path: String { get }
    
    var method: String { get }
    
    var parameters: [String: Any]? { get }
    
    var headers: [String: String]? { get }
    
    var body: BodyRequest? { get }
}

extension NetworkRequest {
    
    var parameters: [String: Any]? { nil }
    
    var headers: [String: String]? {
        return [
            "Content-Type":"application/json",
            "Accept":"application/json"
        ]
    }
    
    var body: BodyRequest? { nil }
}
