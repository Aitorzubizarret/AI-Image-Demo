//
//  EndpointCases.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-03.
//

import Foundation

enum EndpointCases: Endpoint {
    
    case getModels
    
    var httpMethod: String {
        switch self {
        case .getModels:
            return "GET"
        }
    }
    
    var baseURLString: String {
        switch self {
        case .getModels:
            return OpenAI.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .getModels:
            return OpenAI.getModelsURL
        }
    }
    
    var headers: [String : Any]? {
        switch self {
        case .getModels:
            return ["Authorization":"Bearer \(OpenAI.APIKey)",
                    "Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getModels:
            return [:]
        }
    }
    
}
