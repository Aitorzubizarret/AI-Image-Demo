//
//  EndpointCases.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-03.
//

import Foundation

enum EndpointCases: Endpoint {
    
    case getModels
    case getModelById(_ id: String)
    case createImage(description: String, size: String, quantity: Int)
    
    var httpMethod: String {
        switch self {
        case .getModels:
            return "GET"
        case .getModelById:
            return "GET"
        case .createImage:
            return "POST"
        }
    }
    
    var baseURLString: String {
        switch self {
        case .getModels:
            return OpenAI.baseURL
        case .getModelById:
            return OpenAI.baseURL
        case .createImage:
            return OpenAI.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .getModels:
            return OpenAI.getModelsURL
        case .getModelById(let id):
            return "\(OpenAI.getModelByIdURL)\(id)"
        case .createImage:
            return OpenAI.createImageURL
        }
    }
    
    var headers: [String : Any]? {
        switch self {
        case .getModels:
            return ["Authorization":"Bearer \(OpenAI.APIKey)",
                    "Content-Type": "application/json",
                    "Accept": "application/json"]
        case .getModelById:
            return ["Authorization":"Bearer \(OpenAI.APIKey)",
                    "Content-Type": "application/json",
                    "Accept": "application/json"]
        case .createImage:
            return ["Authorization":"Bearer \(OpenAI.APIKey)",
                    "Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getModels:
            return nil
        case .getModelById:
            return nil
        case .createImage(let description, let size, let quantity):
            return ["prompt": description,
                    "n": quantity,
                    "size": size,
                    "response_format": "b64_json"]
        }
    }
    
}
