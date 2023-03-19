//
//  Model.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-03.
//

import Foundation

struct Model: Codable {
    let id: String
    let object: String
    let created: Int
    let owned_by: String
    let permission: [Permission]
    let root: String
    let parent: String? // TODO: - What type?
}
