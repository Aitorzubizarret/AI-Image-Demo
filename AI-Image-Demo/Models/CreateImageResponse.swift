//
//  CreateImageResponse.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-03.
//

import Foundation

struct CreateImageResponse: Codable {
    let created: Int
    let data: [AIImage]
}
