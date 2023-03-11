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
    
    func getPetitionImageData() -> [Data]? {
        if petition.imagesData.isEmpty {
            return nil
        } else {
            var imagesData: [Data] = []
            for imageData in petition.imagesData {
                imagesData.append(imageData)
            }
            return imagesData
        }
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
