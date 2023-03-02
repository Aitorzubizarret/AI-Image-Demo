//
//  MainViewModel.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-02.
//

import Foundation

struct MainViewModel {
    
    // MARK: - Properties
    
    private var apiManager: APIManagerProtocol
    
    var demoText: String = "Hi Aitor"
    
    // MARK: - Methods
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func login() {
        apiManager.login()
    }
    
}
