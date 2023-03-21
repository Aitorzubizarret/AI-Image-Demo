//
//  PetitionsInteractor.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-19.
//

import Foundation
import Combine

class PetitionsInteractor {
    
    // MARK: - Properties (from PresenterToInteractorPetitionsProtocol)
    
    var presenter: InteractorToPresenterPetitionsProtocol?
    var realmManager: InteractorToRealmManagerPetitionsProtocol? {
        didSet {
            guard let _ = realmManager else { return }
            
            setupSubscriptions()
        }
    }
    
    // MARK: Properties
    
    private var subscribedTo: [AnyCancellable] = []
    private var petitions: [Petition] = []
    
    // MARK: - Methods
    
    private func setupSubscriptions() {
        guard let realmManager = realmManager else { return }
        
        realmManager.petitions.sink { receiveCompletion in
            print("Receive Completion")
        } receiveValue: { [weak self] petitions in
            self?.petitionsReceived(petitions: petitions)
        }.store(in: &subscribedTo)
    }
    
    private func petitionsReceived(petitions: [Petition]) {
        print("Interactor - petitionsReceived")
        self.petitions = petitions
        
        presenter?.fetchPetitionsSuccess()
    }
    
}

extension PetitionsInteractor: PresenterToInteractorPetitionsProtocol {
    
    func loadPetitions() {
        guard let realmManager = realmManager else { return }
        
        realmManager.getPetitions()
    }
    
    func numberOfPetitions() -> Int {
        return petitions.count
    }
    
    func petitionIsLoading(at index: Int) -> Bool {
        if petitions[index].imagesData.isEmpty && petitions[index].errorDescription == nil { // && index == 0
            return true
        } else {
            return false
        }
    }
    
    func petitionImagesData(at index: Int) -> [Data] {
        return petitions[index].getDataArray() ?? []
    }
    
    func petitionHasErroDescription(at index: Int) -> Bool {
        var response: Bool = false
        if let errorDescription = petitions[index].errorDescription,
           !errorDescription.isEmpty {
            response = true
        }
        return response
    }
    
    func petitionErrorDescription(at index: Int) -> String {
        return petitions[index].errorDescription ?? ""
    }
    
    func petitionDescription(at index: Int) -> String {
        return petitions[index].imageDescription ?? ""
    }
    
    func petitionId(at index: Int) -> String {
        return petitions[index].id
    }
    
}
