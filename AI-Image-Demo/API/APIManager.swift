//
//  APIManager.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-02.
//

import Foundation

final class APIManager {
    
    // MARK: - Properties
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.ephemeral // Doesn't persist data.
        let session = URLSession(configuration: configuration)
        return session
    }
    
    private var loginURL: String = "https://api.openai.com/v1/models"
    private var loginAPIKey: String = "thisIsNotMyRealAPIKeyHeHe"
    
}

extension APIManager: APIManagerProtocol {
    
    func login() {
        guard let url: URL = URL(string: loginURL) else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            print("Data \(String(describing: data))")
            print("Response \(String(describing: response))")
            print("Error \(String(describing: error))")
        }
        task.resume()
    }
    
}
