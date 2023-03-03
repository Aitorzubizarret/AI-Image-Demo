//
//  MainViewModel.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-02.
//

import Foundation
import Combine

final class MainViewModel {
    
    // MARK: - Properties
    
    private var apiManager: APIManagerProtocol
    
    var demoText: String = "Hi Aitor"
    
    private var subscribedTo: [AnyCancellable] = []
    
    var models: [Model] = [] {
        didSet {
            for model in models {
                print("Model name: \(model.id)")
            }
        }
    }
    var model: Model? {
        didSet {
            guard let model = model else { return }
            
            print("Model \(model)")
        }
    }
    
    // MARK: - Methods
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        apiManager.getModelsResponse.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] receivedGetModelsResponse in
            self?.models = receivedGetModelsResponse.data
        }.store(in: &subscribedTo)
        
        apiManager.getModelByIdResponse.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] receivedModel in
            self?.model = receivedModel
        }.store(in: &subscribedTo)
    }
    
    func getModels() {
        apiManager.getModels()
    }
    
    func getModelById(_ id: String) {
        apiManager.getModelById(id)
    }
    
}
