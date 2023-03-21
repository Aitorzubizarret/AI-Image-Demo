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
    
    // MARK: - Properties (from InteractorToRealmManagerPetitionsProtocol)
    
    var petitions: PassthroughSubject<[Petition], Error> = PassthroughSubject<[Petition], Error>()
    
    // MARK: - Properties (from InteractorToRealmManagerPetitionDetailProtocol)
    
    var petition: PassthroughSubject<Petition, Error> = PassthroughSubject<Petition, Error>()
    
    // MARK: - Methods
    
    init() {
        self.realm = try! Realm()
    }
    
}

// MARK: - RealManager Protocol

extension RealmManager: RealmManagerProtocol {
    
    func addPetition(_ petition: Petition) {
        do {
            try realm.write({
                realm.add(petition)
            })
        } catch let error {
            print("Error RealmManager - addPetition : \(error.localizedDescription)")
        }
    }
    
    func updatePetitionImageData(_ imagesData: [Data]) {
        let petitions = realm.objects(Petition.self)
        
        if let lastPetition = petitions.last {
            do {
                try realm.write({
                    for imageData in imagesData {
                        lastPetition.imagesData.append(imageData)
                    }
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

// MARK: - Interactor to RealmManager Petitions Protocol

extension RealmManager: InteractorToRealmManagerPetitionsProtocol {
    
    func getPetitions() {
        let allPetitions = realm.objects(Petition.self).sorted(byKeyPath: "date", ascending: false)
        petitions.send(allPetitions.toArray())
    }
    
}

// MARK: - Interactor to RealmManager Petition Detail Protocol

extension RealmManager: InteractorToRealmManagerPetitionDetailProtocol {
    
    func getPetition(with id: String) {
        let foundPetitions = realm.objects(Petition.self).filter("id = '\(id)'")
        if foundPetitions.count == 1,
           let foundPetition = foundPetitions.first {
            petition.send(foundPetition)
        } else {
            // TODO: Send error.
        }
    }
    
}
