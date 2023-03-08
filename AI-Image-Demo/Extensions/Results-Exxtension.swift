//
//  Results-Exxtension.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-07.
//

import Foundation
import RealmSwift

extension Results {
    
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
    
}
