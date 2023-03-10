//
//  APIManagerProtocol.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-02.
//

import Foundation
import Combine

protocol APIManagerProtocol {
    
    // MARK: - Properties
    
    var getModelsResponse: PassthroughSubject<GetModelsResponde, Error> { get set }
    var getModelByIdResponse: PassthroughSubject<Model, Error> { get }
    var getCreateImageResponse: PassthroughSubject<CreateImageResponse, Error> { get }
    
    // MARK: - Methods
    
    func getModels()
    func getModelById(_ id: String)
    func createImage(description: String, size: String, quantity: Int)
    
}
