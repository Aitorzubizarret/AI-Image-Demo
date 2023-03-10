//
//  ImageDetailViewModel.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-10.
//

import Foundation

final class ImageDetailViewModel {
    
    // MARK: - Properties
    
    var petition: Petition
    
    // MARK: - Methods
    
    init(petition: Petition) {
        self.petition = petition
    }
    
    func getPetitionImageData() -> Data? {
        return petition.imageData
    }
    
    func getErrorDescription() -> String? {
        petition.errorDescription
    }
    
    func getImageDescription() -> String {
        if let imageDescription = petition.imageDescription {
            return imageDescription
        } else {
            return ""
        }
    }
    
}
