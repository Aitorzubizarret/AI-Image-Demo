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
        
        // Dependency injection to View.
        viewController.presenter = presenter
        
        // Dependency injection to Presenter.
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = PetitionsInteractor()
        viewController.presenter?.router = PetitionsRouter()
        
        // Dependency injection to Interactor.
        viewController.presenter?.interactor?.presenter = presenter
        
        // Navigation Controller.
        let navController = UINavigationController(rootViewController: viewController)
        
        return navController
    }
    
}
