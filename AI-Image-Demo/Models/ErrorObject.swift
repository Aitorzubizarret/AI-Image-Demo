//
//  ErrorObject.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-05.
//

import Foundation

struct ErrorObject: Codable {
    let code: Int?  // TODO: - What type?
    let message: String
    let param: Int?  // TODO: - What type?
    let type: String
}
