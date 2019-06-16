//
//  FoursquareError.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 11/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Foundation

enum FoursquareError: Error {
    case JSONParsing
    case noResponse
}

// MARK: - Error Descriptions
extension FoursquareError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .JSONParsing:
            return NSLocalizedString("Failed to parse JSON.", comment: "Parsing Error")
        case .noResponse:
            return NSLocalizedString("No respose from server.", comment: "Server Error")
        }
    }
}

// MARK: - Error MetaData
extension FoursquareError: CustomNSError {
    public static var errorDomain: String {
        return "com.foursquare.error"
    }
    
    public var errorCode: Int {
        switch self {
        case .JSONParsing:
            return 1001
        case .noResponse:
            return 1002
        }
    }
    
    public var errorUserInfo: [String: Any] {
        switch self {
        case .JSONParsing:
            return [NSLocalizedDescriptionKey: "Failed to parse JSON."]
        case .noResponse:
            return [NSLocalizedDescriptionKey: "No respose from server"]
        }
    }
}
