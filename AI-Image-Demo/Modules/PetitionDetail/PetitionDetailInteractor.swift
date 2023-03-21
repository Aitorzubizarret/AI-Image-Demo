//
//  PetitionDetailInteractor.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-20.
//

import Foundation
import Combine

class PetitionDetailInteractor {
    
    // MARK: - Properties
    
    private var subscribedTo: [AnyCancellable] = []
    private var petition: Petition?
    
    // MARK: - Properties (from PresenterToInteractorPetitionDetailProtocl)
    
    var presenter: InteractorToPresenterPetitionDetailProtocol?
    var realmManager: InteractorToRealmManagerPetitionDetailProtocol? {
        didSet {
            guard let _ = realmManager else { return }
            
            setupSubscriptions()
        }
    }
    
    // MARK: - Methods
    
    private func setupSubscriptions() {
        guard let realmManager = realmManager else { return }
        
        realmManager.petition.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] petition in
            self?.petitionReceived(petition: petition)
        }.store(in: &subscribedTo)
    }
    
    private func petitionReceived(petition: Petition) {
        self.petition = petition
        
        presenter?.retrievePetitionSuccess()
    }
    
}

extension PetitionDetailInteractor: PresenterToInteractorPetitionDetailProtocol {
    
    func getPetition(with id: String) {
        realmManager?.getPetition(with: id)
    }
    
    func getPetitionImagesData() -> [Data] {
        return petition?.getDataArray() ?? []
    }
    
    func getPetitionErrorDescription() -> String {
        return petition?.errorDescription ?? ""
    }
    
    func getPetitionDescription() -> String {
        return petition?.imageDescription ?? ""
    }
    
}
