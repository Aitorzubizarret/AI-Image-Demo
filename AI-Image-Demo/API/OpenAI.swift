//
//  OpenAI.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-03.
//

import Foundation

struct OpenAI {
    static var APIKey: String = "thisIsNotMyRealAPIKeyHeHe"
    
    static var baseURL: String = "https://api.openai.com"
    
    static var getModelsURL:    String = "/v1/models"
    static var getModelByIdURL: String = "/v1/models/"
    static var createImageURL:  String = "/v1/images/generations"
}
