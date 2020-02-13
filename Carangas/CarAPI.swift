//
//  CarAPI.swift
//  Carangas
//
//  Created by perfil on 12/02/20.
//  Copyright © 2020 Eric Brito. All rights reserved.
//

import Foundation

enum APIError: Error {
    case badURL
    case taskError
    case badResponse
    case invalidStatusCode(Int)
    case noData
    case decodeError
}

class CarAPI {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
  
    private static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        
        configuration.allowsCellularAccess = false
        configuration.timeoutIntervalForRequest = 30
        configuration.httpAdditionalHeaders = ["Content-Type":"application/json"]
        configuration.httpMaximumConnectionsPerHost = 5
        
        return configuration
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    static func loadCars(onComplete: @escaping (Result<[Car], APIError>) -> Void ){
        guard let url = URL(string: basePath) else {
            //ERRO NA URL
            onComplete(.failure(.badURL))
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                onComplete(.failure(.taskError))
                print("Deu ruim !!!")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
               onComplete(.failure(.badResponse))
                print ("Sem RESPONSE")
                return
            }
            if response.statusCode != 200 {
                onComplete(.failure(.invalidStatusCode(response.statusCode)))
                print("DEU RUIM 2 NA RESPOSTA")
                return
            }
            
            guard let data = data else {
                onComplete(.failure(.noData))
                print("DEU RUIM 3 - SEM DADOS")
                return
            }
            do {
                let cars = try JSONDecoder().decode([Car].self, from: data)
                print("Voce tem \(cars.count) carros")
                onComplete(.success(cars))
                
            } catch {
                print(error)
                onComplete(.failure(.decodeError))

            }
            
        }
        
        task.resume()
        
    }
    
    class func createCar(_ car: Car, onComplete: @escaping (Result<Bool, APIError>) -> Void){
        request(.create, car: car, onComplete: onComplete)
    }

    class func updateCar(_ car: Car, onComplete: @escaping (Result<Bool, APIError>) -> Void){
        request(.update, car: car, onComplete: onComplete)
    }
    
    class func deleteCar(_ car: Car, onComplete: @escaping (Result<Bool, APIError>) -> Void){
        request(.delete, car: car, onComplete: onComplete)
    }
    
    private class func request(_ operation: RESTOperation, car: Car, onComplete: @escaping (Result<Bool, APIError>) -> Void){
        
        let urlString = basePath + "/" + (car._id ?? "")
        let url = URL(string: urlString)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = operation.rawValue
        urlRequest.httpBody = try? JSONEncoder().encode(car)
        //urlRequest.allHTTPHeaderFields = []
        
        
        session.dataTask(with: urlRequest) { (data, _, _) in
            if data == nil {
                onComplete(.failure(.taskError))
            }else {
                onComplete(.success(true))
            }
        }.resume()
        
    }
    
    
    
}


enum RESTOperation: String {
    case delete = "DELETE"
    case update = "PUT"
    case create = "POST"
    
}
