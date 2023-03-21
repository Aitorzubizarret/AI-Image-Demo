//
//  RealmManagerProtocol.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-06.
//

import Foundation
import RealmSwift
import Combine

protocol RealmManagerProtocol {
    
    // MARK: - Properties
    
    var realm: Realm { get set }
    
    // MARK: - Methods
    
    func addPetition(_ petition: Petition)
    func updatePetitionImageData(_ imageData: [Data])
    func updatePetitionErrorDescription(_ errorDescription: String)
    
}
