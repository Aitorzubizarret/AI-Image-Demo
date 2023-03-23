//
//  PetitionDetailContract.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-20.
//

import UIKit
import Combine

// MARK: - View

/// View Output (Presenter -> View)
protocol PresenterToViewPetitionDetailProtocol {
    
    var presenter: ViewToPresenterPetitionDetailProtocol? { get set }
    
    func onGetPetitionSuccess()
    func onGetPetitionFailure(errorDescription: String)
    
}

// MARK: - Presenter

/// View Input (View -> Presenter)
protocol ViewToPresenterPetitionDetailProtocol {
    
    var view: PresenterToViewPetitionDetailProtocol? { get set }
    var interactor: PresenterToInteractorPetitionDetailProtocol? { get set }
    var router: PresenterToRouterPetitionDetailProtocol? { get set }
    
    var petitionId: String { get set }
    
    init(petitionId: String)
    
    func viewDidLoad()
    
    func petitionImagesData() -> [Data]
    func petitionErrorDescription() -> String
    func petitionDescription() -> String
    
}

/// Interactor Input (Interactor -> Presenter)
protocol InteractorToPresenterPetitionDetailProtocol {
    
    func retrievePetitionSuccess()
    func retrievePetitionFailure(errorDescription: String)
    
}

// MARK: - Interactor

/// Interactor Output (Presenter -> Interactor)
protocol PresenterToInteractorPetitionDetailProtocol {
    
    var presenter: InteractorToPresenterPetitionDetailProtocol? { get set }
    var realmManager: InteractorToRealmManagerPetitionDetailProtocol? { get set }
    
    func getPetition(with id: String)
    
    func getPetitionImagesData() -> [Data]
    func getPetitionErrorDescription() -> String
    func getPetitionDescription() -> String
    
}

// MARK: - Router

/// Router Output (Presenter -> Router)
protocol PresenterToRouterPetitionDetailProtocol {
    
    static func createModule(with petitionId: String) -> UIViewController
    
}

// MARK: - Realm Manager

/// RealmManager Output (Interactor -> Realm Manager)
protocol InteractorToRealmManagerPetitionDetailProtocol {
    
    var petition: PassthroughSubject<Petition, Error> { get set }
    
    func getPetition(with id: String)
    
}
