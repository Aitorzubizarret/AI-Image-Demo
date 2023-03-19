//
//  CreateImageFormBuilder.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-16.
//

import UIKit

struct CreateImageFormBuilder {
    
    static func create(viewModel: MainViewModel) -> UIViewController {
        let viewController = CreateImageFormViewController(viewModel: viewModel)
        
        return viewController
    }
    
}
