//
//  DataRequest.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 10/06/2023.
//

import Foundation

let baseURL: String = "https://api.disneyapi.dev"

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol DataRequest {
    associatedtype Response
    
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: [String : String] { get }
    
    func decode(data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    func decode(data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequest {
    
    var parameters: [String : String] { [:] }
}

