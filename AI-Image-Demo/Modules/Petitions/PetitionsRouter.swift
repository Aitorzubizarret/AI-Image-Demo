//
//  PetitionsRouter.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-19.
//

import UIKit

class PetitionsRouter {}

extension PetitionsRouter: PresenterToRouterPetitionsProtocol {
    
    static func createModule() -> UINavigationController {
        // View Controller.
        let viewController = PetitionsViewController()
        
        // Presenter.
        let presenter: ViewToPresenterPetitionsProtocol & InteractorToPresenterPetitionsProtocol = PetitionsPresenter()
        
        // Realm Manager.
        let realmManager: InteractorToRealmManagerPetitionsProtocol = RealmManager()
        
        // Dependency injection to View.
        viewController.presenter = presenter
        
        // Dependency injection to Presenter.
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = PetitionsInteractor()
        viewController.presenter?.router = PetitionsRouter()
        
        // Dependency injection to Interactor.
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.realmManager = realmManager
        
        // Navigation Controller.
        let navController = UINavigationController(rootViewController: viewController)
        
        return navController
    }
    
    func showPetitionDetail(on view: PresenterToViewPetitionsProtocol, petitionId: String) {
        // View controller.
        let petitionDetailViewController = PetitionDetailRouter.createModule(with: petitionId)
        
        let viewController = view as! PetitionsViewController
        viewController.navigationController?.show(petitionDetailViewController, sender: true)
    }
    
}
