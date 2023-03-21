//
//  PetitionDetailRouter.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-20.
//

import UIKit

class PetitionDetailRouter {}

extension PetitionDetailRouter: PresenterToRouterPetitionDetailProtocol {
    
    static func createModule(with petitionId: String) -> UIViewController {
        // View Controller.
        let viewController = PetitionDetailViewController()

        // Presenter.
        let presenter: ViewToPresenterPetitionDetailProtocol & InteractorToPresenterPetitionDetailProtocol = PetitionDetailPresenter()

        // Realm Manager.
        let realmManager: InteractorToRealmManagerPetitionDetailProtocol = RealmManager()

        // Dependency injection to View.
        viewController.presenter = presenter

        // Dependency injection to Presenter.
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = PetitionDetailInteractor()
        viewController.presenter?.router = PetitionDetailRouter()
        viewController.presenter?.petitionId = petitionId // The ID of the selected petition that will be searched in Realm and displayed in the view.

        // Dependency injection to Interactor.
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.realmManager = realmManager

        return viewController
    }
    
}
