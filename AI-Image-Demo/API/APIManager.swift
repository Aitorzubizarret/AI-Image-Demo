//
//  APIManager.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-02.
//

import Foundation
import Combine

final class APIManager {
    
    // MARK: - Properties
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.ephemeral // Doesn't persist data.
        let session = URLSession(configuration: configuration)
        return session
    }
    
    private var OpenAI_APIKey: String = "thisIsNotMyRealAPIKeyHeHe"
    
    private enum OpenAI_URLs: String {
        case getModels = "https://api.openai.com/v1/models"
    }
    
    var getModelsResponse = PassthroughSubject<GetModelsResponde, Error>()
    
    // MARK: - Methods
    
    private func getRequest(url: OpenAI_URLs) -> URLRequest? {
        guard let url: URL = URL(string: url.rawValue) else { return nil }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization":"Bearer \(OpenAI_APIKey)"]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        return request
    }
}

extension APIManager: APIManagerProtocol {
    
    func getModels() {
        guard let request = getRequest(url: .getModels) else { return }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response received from the server")
                return
            }
            
            guard let responseData = data else {
                print("nil data received from the server")
                return
            }
            
            do {
                let getModelsResponse = try JSONDecoder().decode(GetModelsResponde.self, from: responseData)
                self.getModelsResponse.send(getModelsResponse)
            } catch let error {
                print("Error \(error)")
            }
            
        }
        task.resume()
    }
    
}
