//
//  GetModelsResponse.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-03.
//

import Foundation

struct GetModelsResponde: Codable {
    let object: String
    let data: [Model]
}
