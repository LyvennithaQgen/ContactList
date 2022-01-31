//
//  NetworkLayer.swift
//  ContactList
//
//  Created by Lyvennitha on 31/01/22.
//

import Foundation

enum NetworkConstants: String{
    case baseURL = "http://jsonplaceholder.typicode.com/photos"
}

class NetworkLayer{
    
    func getNew<T: Codable>(OnResponse: @escaping (Result<T, Error>) -> ()){
        var urlRequest = URLRequest(url: URL(string: NetworkConstants.baseURL.rawValue)!)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            
            do {
                if data != nil{
                let res = try JSONDecoder().decode(T.self, from: data!)
                OnResponse(.success(res))
                }
            } catch {
                print(error)
                OnResponse(.failure(error))
            }
           
        }.resume()
        
    }
    
}
