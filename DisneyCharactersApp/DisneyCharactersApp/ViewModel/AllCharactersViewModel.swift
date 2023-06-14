//
//  CharactersViewModel.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 10/06/2023.
//

import Foundation
import UIKit

protocol CharactersViewModel: AnyObject {
    
    typealias CharacterResultBlock = (_ success: Bool, _ error: NSError?) -> Void
    var characters: [Character] { set get }
    func getAllCharacters(completion:  @escaping CharacterResultBlock)
}

final class AllCharactersViewModel: CharactersViewModel {
    
    private let networkService: NetworkService
    private var persistenceManager : PersistenceManager
    
    var characters: [Character] = []
    
    init(networkService: NetworkService,
         persistenceManager: PersistenceManager) {
        
        self.networkService = networkService
        self.persistenceManager = persistenceManager
    }
    
    //MARK: Public methods
    
    func getAllCharacters(completion:  @escaping CharacterResultBlock) {
        
        let request = CharactersRequest()
        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let characters):
                
                self?.characters = characters
                self?.store(characters: characters)
                completion(true, nil)
                
                //                self?.persistenceManager.getAllCharacters(completion: { result in
                //                    self?.characters = result ?? []
                //                    completion(true, nil)
                //
                //                })
                
            case .failure(let error as NSError):
                // On any network failure try to fetch data from DB
                self?.persistenceManager.getAllCharacters(completion: { result in
                    self?.characters = result ?? []
                    completion(self?.characters.count == 0, error)
                })
            }
        }
    }
    
    //MARK: Private methods
    
    private func store(characters: [Character]) {
        self.persistenceManager.saveCharacters(characters: characters)
    }
}
