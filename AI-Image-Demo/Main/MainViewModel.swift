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
    }
    
    func getModels() {
        apiManager.getModels()
    }
    
}
