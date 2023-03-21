//
//  PetitionsContract.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-19.
//

import UIKit
import Combine

// MARK: - View Input (View -> Presenter)

protocol ViewToPresenterPetitionsProtocol {
    
    var view: PresenterToViewPetitionsProtocol? { get set }
    var interactor: PresenterToInteractorPetitionsProtocol? { get set }
    var router: PresenterToRouterPetitionsProtocol? { get set }
    
    func viewDidLoad()
    
    func numberOfRowsInSection() -> Int
    func petitionIsLoading(at index: Int) -> Bool
    func petitionImagesData(at index: Int) -> [Data]
    func petitionHasErroDescription(at index: Int) -> Bool
    func petitionErrorDescription(at index: Int) -> String
    func petitionDescription(at index: Int) -> String
    
}

// MARK: - View Output (Presenter -> View)

protocol PresenterToViewPetitionsProtocol {
    
    var presenter: ViewToPresenterPetitionsProtocol? { get set }
    
    func onGetPetitionsSuccess()
    func onGetPetitionsFailure(errorDescription: String)
    
}

// MARK: - Interactor Output (Interactor -> Presenter)

protocol InteractorToPresenterPetitionsProtocol {
    
    func fetchPetitionsSuccess()
    func fetchPetitionsFailure()
    
}

// MARK: - Interactor Input (Presenter -> Interactor)

protocol PresenterToInteractorPetitionsProtocol {
    
    var presenter: InteractorToPresenterPetitionsProtocol? { get set }
    var realmManager: InteractorToRealmManagerPetitionsProtocol? { get set }
    
    func loadPetitions()
    func numberOfPetitions() -> Int
    func petitionIsLoading(at index: Int) -> Bool
    func petitionImagesData(at index: Int) -> [Data]
    func petitionHasErroDescription(at index: Int) -> Bool
    func petitionErrorDescription(at index: Int) -> String
    func petitionDescription(at index: Int) -> String
    
}

// MARK: - Interactor Ouput (Interactor -> RealmManager)

protocol InteractorToRealmManagerPetitionsProtocol {
    
    var petitions: PassthroughSubject<[Petition], Error> { get set }
    
    func getPetitions()
    
}

// MARK: - Router Output (Presenter -> Router)

protocol PresenterToRouterPetitionsProtocol {
    
    static  func createModule() -> UINavigationController
    
}
