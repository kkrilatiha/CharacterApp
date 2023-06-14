//
//  NetworkService.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 10/06/2023.
//

import Foundation

protocol NetworkService {
    func request<Request: DataRequest>(_ request: Request,
                                       completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class DefaultNetworkService: NetworkService {
    
    func request<Request: DataRequest>(_ request: Request,
                                       completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        guard var urlComponent = URLComponents(string: request.url) else {
            return completion(.failure(NSError(type: .URLFailure)))
        }
        
        var parameters: [URLQueryItem] = []
        
        request.parameters.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            parameters.append(urlQueryItem)
        }
        
        urlComponent.queryItems = parameters
        
        guard let url = urlComponent.url else {
            return completion(.failure(NSError(type: .URLFailure)))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(NSError(type: .ServiceUnavailable)))
            }
            
            guard let data = data else {
                return completion(.failure(NSError(type: .NoDataProvided)))
            }
            
            do {
                try completion(.success(request.decode(data: data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
