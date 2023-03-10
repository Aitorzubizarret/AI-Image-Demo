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
    private var realmManager: RealmManagerProtocol
    
    private var subscribedTo: [AnyCancellable] = []
    var petitions = PassthroughSubject<[Petition], Error>()
    var receivedAIImage = PassthroughSubject<AIImage, Error>()
    
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
    
    init(apiManager: APIManagerProtocol, realmManager: RealmManagerProtocol) {
        self.apiManager = apiManager
        self.realmManager = realmManager
        
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
        
        apiManager.getCreateImageResponse.sink { receiveCompletion in
            switch receiveCompletion {
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.realmManager.updatePetitionErrorDescription(error.localizedDescription)
                    self?.realmManager.getPetitions()
                }
            case .finished:
                print("")
            }
        } receiveValue: { [weak self] receiveCreateImageResponse in
            if !receiveCreateImageResponse.data.isEmpty,
               let receivedArtificilaImage = receiveCreateImageResponse.data.first {
                DispatchQueue.main.async {
                    self?.realmManager.updatePetitionImageData(receivedArtificilaImage.b64_json)
                    self?.realmManager.getPetitions()
                }
            }
        }.store(in: &subscribedTo)
        
        realmManager.petitions.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] receivedPetitions in
            self?.petitions.send(receivedPetitions)
        }.store(in: &subscribedTo)
    }
    
    func getModels() {
        apiManager.getModels()
    }
    
    func getModelById(_ id: String) {
        apiManager.getModelById(id)
    }
    
    func getPetitions() {
        realmManager.getPetitions()
    }
    
    func createImage(description: String, size: String, quantity: Int) {
        // Create the Petition.
        let petition = Petition()
        petition.imageDescription = description
        
        // Save it in RealmManager.
        realmManager.addPetition(petition)
        realmManager.getPetitions()
        
        // Call the API to create it in the server and (if no problem) received it.
        apiManager.createImage(description: description, size: size, quantity: quantity)
    }
    
}
