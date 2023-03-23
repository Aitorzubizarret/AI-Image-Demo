//
//  PetitionDetailPresenter.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-20.
//

import Foundation

class PetitionDetailPresenter {
    
    // MARK: - Properties (from ViewToPresenterPetitionDetailProtocol)
    
    var view: PresenterToViewPetitionDetailProtocol?
    var interactor: PresenterToInteractorPetitionDetailProtocol?
    var router: PresenterToRouterPetitionDetailProtocol?
    
    var petitionId: String
    
    // MARK: - Methods (from ViewToPresenterPetitionDetailProtocol)
    
    required init(petitionId: String) {
        self.petitionId = petitionId
    }
    
}

extension PetitionDetailPresenter: ViewToPresenterPetitionDetailProtocol {
    
    func viewDidLoad() {
        interactor?.getPetition(with: petitionId)
    }
    
    func petitionImagesData() -> [Data] {
        return interactor?.getPetitionImagesData() ?? []
    }
    
    func petitionErrorDescription() -> String {
        return interactor?.getPetitionErrorDescription() ?? ""
    }
    
    func petitionDescription() -> String {
        return interactor?.getPetitionDescription() ?? ""
    }
    
}

extension PetitionDetailPresenter: InteractorToPresenterPetitionDetailProtocol {
    
    func retrievePetitionSuccess() {
        view?.onGetPetitionSuccess()
    }
    
    func retrievePetitionFailure(errorDescription: String) {
        print("Retrieve petition failure")
    }
    
}
