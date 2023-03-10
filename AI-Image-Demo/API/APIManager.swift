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
    var getModelByIdResponse = PassthroughSubject<Model, Error>()
    var getCreateImageResponse = PassthroughSubject<CreateImageResponse, Error>()
    
    var isError: Bool = false
    
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
        
        // Body Fields
        if let bodyFields = endpoint.body {
            do {
                let jsonData: Data = try JSONSerialization.data(withJSONObject: bodyFields, options: [])
                urlRequest.httpBody = jsonData
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            // Error
            if let error = error {
                print("Error APIManager Request : \(error.localizedDescription)")
                completion(.failure(CustomError.unknown(description: "\(error.localizedDescription)")))
                return
            }
            
            // Response
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if !(200...299).contains(httpResponse.statusCode) {
                let errorCode: String = "\(httpResponse.statusCode)"
                var errorMessage: String = ""
                
                if let responseData = data {
                    if let response = try? JSONDecoder().decode(ErrorResponse.self, from: responseData) {
                        errorMessage = response.error.message
                    }
                }
                
                print("Error APIManager Request : Invalid response received from the server. Status Code: \(errorCode) - Error message: \(errorMessage)")
                completion(.failure(CustomError.unknown(description: "Invalid response received from the server. Status Code: \(errorCode) - Error message: \(errorMessage)")))
                return
            }
            
            // Data
            guard let responseData = data else {
                print("Error APIManager Request : nil data received from the server")
                completion(.failure(CustomError.unknown(description: "nil data received from the server")))
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
    
    func getModelById(_ id: String) {
        let getModelsByIdEndpoint = EndpointCases.getModelById(id)
        request(endpoint: getModelsByIdEndpoint) { (result: Result<Model, Error>) in
            switch result {
            case .success(let model):
                self.getModelByIdResponse.send(model)
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func createImage(description: String, size: String, quantity: Int) {
        let createImageEndpoint = EndpointCases.createImage(description: description, size: size, quantity: quantity)
        request(endpoint: createImageEndpoint) { (result: Result<CreateImageResponse, Error>) in
            switch result {
            case .success(let createImageResponse):
                self.getCreateImageResponse.send(createImageResponse)
            case .failure(let error):
                self.getCreateImageResponse.send(completion: .failure(CustomError.unknown(description: "\(error.localizedDescription)")))
            }
        }
    }
    
}
