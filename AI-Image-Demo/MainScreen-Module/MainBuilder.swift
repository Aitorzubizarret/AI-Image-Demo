//
//  MainBuilder.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-14.
//

import UIKit

struct MainBuilder {
    
    static func create() -> UIViewController {
        // Create the APIManager.
        let apiManager: APIManagerProtocol = APIManager()
        
        // Create the RealmManager.
        let realmManager: RealmManagerProtocol = RealmManager()
        
        // Create the ViewModel.
        let viewModel = MainViewModel(apiManager: apiManager, realmManager: realmManager)
        
        // Create the ViewController.
        let viewController = MainViewController(viewModel: viewModel)
        
        return viewController
    }
    
}
