//
//  NetworkRouter.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 16/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    case fetchRestaurants(coordinates: String)
    case fetchPhotos(venueId: String)
    case fetchDetails(venueId: String)
    
    static let baseURLString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
    
    var method: HTTPMethod {
        switch self {
        case .fetchRestaurants, .fetchPhotos, .fetchDetails:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchRestaurants:
            return "/venues/search"
        case let .fetchPhotos(venueId):
            return "/venues/\(venueId)/photos"
        case let .fetchDetails(venueId):
            return "/venues/\(venueId)"
        }
    }
    var parameters: [String: AnyObject]? {
        switch self {
        case let .fetchRestaurants(coordinates):
            let authorizationParams = getAuthorizationParameters()
            let params = ["ll": coordinates, "client_id" :  authorizationParams.0 , "client_secret": authorizationParams.1, "categoryId": "4d4b7105d754a06374d81259", "v": authorizationParams.2]
            return params as [String : AnyObject]?
        case .fetchPhotos, .fetchDetails:
            let authorizationParams = getAuthorizationParameters()
            let params = ["client_id" :  authorizationParams.0 , "client_secret": authorizationParams.1, "v": authorizationParams.2]
            return params as [String : AnyObject]?
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        print("URL: \(urlRequest.url)")
        return urlRequest
    }
    
    func getAuthorizationParameters() -> (String, String, String){
        let bundle = Bundle.main
        let clientId = bundle.object(forInfoDictionaryKey: "CLIENT_ID") as? String ?? ""
        let clientSecret = bundle.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String ?? ""
        let todaysDate = Date().description.prefix(10).replacingOccurrences(of: "-", with: "")
        
        return (clientId, clientSecret, todaysDate)
    }

}
