//
//  CharactersDetailsViewModel.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 10/06/2023.
//

import UIKit

protocol CharactersDetailsViewModel {
    typealias ImageResultBlock = (_ image: UIImage?, _ error: NSError? ) -> Void
    var character: Character { set get }
    func iconForCharacter(completion: @escaping ImageResultBlock)
}

final class CharactersInfoViewModel: CharactersDetailsViewModel {
    
    var character: Character
    lazy private var networkService: NetworkService = DefaultNetworkService()
    
    init(character: Character) {
        self.character = character
    }
    
    func iconForCharacter(completion: @escaping ImageResultBlock) {
        guard let url = URL(string: character.imageUrl) else { return }
        
        if let imageFromCache = ImageManager.shared.cachedImage(forKey: url)   {
            completion(imageFromCache, nil)
        } else {
            downloadIconForCharacter(completion: completion)
        }
    }
    
    
    private func downloadIconForCharacter(completion: @escaping ImageResultBlock) {
        
        guard let url = URL(string: character.imageUrl) else { return }
        
        let request = ImageRequest(url: character.imageUrl)
        networkService.request(request) { [] result in
            
            switch result {
            case .success(let image):
                
                ImageManager.shared.cacheImage(image, forKey: url)
                completion(image, nil)
                
            case .failure(let error):
                completion(nil, error as NSError)
            }
            
        }
    }
}
