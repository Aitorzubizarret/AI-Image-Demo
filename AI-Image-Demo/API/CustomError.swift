//
//  CustomError.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-05.
//

import Foundation

enum CustomError: Error {
    case unknown(description: String)
}

extension CustomError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown(let description):
            return "Error : \(description)"
        }
    }
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown(let description):
            return NSLocalizedString("\(description)", comment: "Error")
        }
    }
}
