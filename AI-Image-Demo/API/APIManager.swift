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
    
    var getModelsResponse = PassthroughSubject<GetModelsResponde, Error>()
    
    // MARK: - Methods
    
    private func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        // URL
        let url: URL = URL(string: endpoint.url)!
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = endpoint.httpMethod
        
        // Header Fields
        endpoint.headers?.forEach({ header in
            urlRequest.setValue(header.value as? String, forHTTPHeaderField: header.key)
        })
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
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
                let response = try JSONDecoder().decode(T.self, from: responseData)
                completion(.success(response))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

extension APIManager: APIManagerProtocol {
    
    func getModels() {
        let getModelsEndpoint = EndpointCases.getModels
        request(endpoint: getModelsEndpoint) { (result: Result<GetModelsResponde, Error>) in
            switch result {
            case .success(let getModelsResponse):
                self.getModelsResponse.send(getModelsResponse)
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
}
