//
//  Permission.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-03.
//

import Foundation

struct Permission: Codable {
    let id: String
    let object: String
    let created: Int
    let allow_create_engine: Bool
    let allow_sampling: Bool
    let allow_logprobs: Bool
    let allow_search_indices: Bool
    let allow_view: Bool
    let allow_fine_tuning: Bool
    let organization: String
    let group: String? // TODO: - What type?
    let is_blocking: Bool
}
