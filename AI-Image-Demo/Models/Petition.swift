//
//  Petition.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-06.
//

import Foundation
import RealmSwift

final class Petition: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var imageDescription: String?
    var imagesData = List<Data>()
    @objc dynamic var errorDescription: String?
}

extension Petition {
    
    func getDataArray() -> [Data]? {
        if !imagesData.isEmpty {
            var dataArray: [Data] = []
            for imageData in imagesData {
                dataArray.append(imageData)
            }
            return dataArray
        } else {
            return nil
        }
    }
    
}
