//
//  CharactersRequest.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 10/06/2023.
//

import Foundation

struct CharactersRequest: DataRequest {
    
    let allCharactersURL = "/character"
    
    var url: String {
        return baseURL + allCharactersURL
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(data: Data) throws -> [Character] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let response = try decoder.decode(AllCharactersResponse.self, from: data)
        return response.data
    }
}

public struct AllCharactersInfoResponse: Codable {
    public let count: Int
    public let totalPages: Int
    public let previousPage: String?
    public let nextPage: String?
}

public struct AllCharactersResponse: Codable {
    public let info: AllCharactersInfoResponse
    public let data: [Character]
}
