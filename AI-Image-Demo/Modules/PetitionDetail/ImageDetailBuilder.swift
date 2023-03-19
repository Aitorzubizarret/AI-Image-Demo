//
//  ImageDetailBuilder.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-15.
//

import UIKit

struct ImageDetailBuilder {
    
    static func create(petition: Petition) -> UIViewController {
        // Create the ViewModel.
        let viewModel = ImageDetailViewModel(petition: petition)
        
        // Create the ViewController.
        let viewController = ImageDetailViewController(viewModel: viewModel)
        
        return viewController
    }
    
}
