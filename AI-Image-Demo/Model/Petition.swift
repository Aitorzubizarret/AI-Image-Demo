//
//  Petition.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-06.
//

import Foundation

final class Petition {
    
    // MARK: - Properties
    
    var date: Date
    private var description: String?
    var imageData: Data?
    var errorDescription: String?
    
    // MARK: - Methods
    
    init(description: String) {
        self.date = Date()
        self.description = description
        self.imageData = nil
        self.errorDescription = nil
    }
    
    func getDescription() -> String {
        return description ?? ""
    }
    
}
