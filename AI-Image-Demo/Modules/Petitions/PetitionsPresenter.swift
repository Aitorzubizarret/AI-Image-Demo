//
//  PetitionsPresenter.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-19.
//

import Foundation

class PetitionsPresenter {
    
    // MARK: - Properties (from ViewToPresenterPetitionsProtocol)
    
    var view: PresenterToViewPetitionsProtocol?
    var interactor: PresenterToInteractorPetitionsProtocol?
    var router: PresenterToRouterPetitionsProtocol?
    
}

extension PetitionsPresenter: ViewToPresenterPetitionsProtocol {
    
    func viewDidLoad() {
        interactor?.loadPetitions()
    }
    
    func numberOfRowsInSection() -> Int {
        return interactor?.numberOfPetitions() ?? 0
    }
    
    func petitionIsLoading(at index: Int) -> Bool {
        return interactor?.petitionIsLoading(at: index) ?? false
    }
    
    func petitionImagesData(at index: Int) -> [Data] {
        return interactor?.petitionImagesData(at: index) ?? []
    }
    
    func petitionHasErroDescription(at index: Int) -> Bool {
        return interactor?.petitionHasErroDescription(at: index) ?? false
    }
    
    func petitionErrorDescription(at index: Int) -> String {
        return interactor?.petitionErrorDescription(at: index) ?? ""
    }
    
    func petitionDescription(at index: Int) -> String {
        return interactor?.petitionDescription(at: index) ?? ""
    }
    
    func didSelectRowAt(_ index: Int) {
        let petitionId: String? = interactor?.petitionId(at: index)
        
        guard let view = view,
              let petitionId = petitionId else { return }
        
        router?.showPetitionDetail(on: view, petitionId: petitionId)
    }
    
}

extension PetitionsPresenter: InteractorToPresenterPetitionsProtocol {
    
    func fetchPetitionsSuccess() {
        view?.onGetPetitionsSuccess()
    }
    
    func fetchPetitionsFailure() {
        print("Fetch petitions failure")
    }
    
}
