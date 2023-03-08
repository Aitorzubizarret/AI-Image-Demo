//
//  RealmManager.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-06.
//

import Foundation
import RealmSwift
import Combine

final class RealmManager {
    
    // MARK: - Properties
    
    var realm: Realm
    
    var petitions = PassthroughSubject<[Petition], Error>()
    
    // MARK: - Methods
    
    init() {
        self.realm = try! Realm()
    }
    
}

// MARK: - RealManager Protocol

extension RealmManager: RealmManagerProtocol {
    
    func getPetitions() {
        let allPetitions = realm.objects(Petition.self).sorted(byKeyPath: "date", ascending: false)
        petitions.send(allPetitions.toArray())
    }
    
    func addPetition(_ petition: Petition) {
        do {
            try realm.write({
                realm.add(petition)
            })
        } catch let error {
            print("Error RealmManager - addPetition : \(error.localizedDescription)")
        }
    }
    
    func updatePetitionImageData(_ imageData: Data) {
        let petitions = realm.objects(Petition.self)
        
        if let lastPetition = petitions.last {
            do {
                try realm.write({
                    lastPetition.imageData = imageData
                })
            } catch let error {
                print("Error RealmManager - updatePetitionImageData : \(error.localizedDescription)")
            }
        }
    }
    
    func updatePetitionErrorDescription(_ errorDescription: String) {
        let petitions = realm.objects(Petition.self)
        
        if let lastPetition = petitions.last {
            do {
                try realm.write({
                    lastPetition.errorDescription = errorDescription
                })
            } catch let error {
                print("Error RealmManager - updatePetitionErrorDescription : \(error.localizedDescription)")
            }
        }
    }
    
}
