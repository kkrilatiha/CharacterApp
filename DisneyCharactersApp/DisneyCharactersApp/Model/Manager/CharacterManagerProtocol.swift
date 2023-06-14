//
//  CharacterRepository.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 11/06/2023.
//

import Foundation
import CoreData


protocol CharacterManager {
    
    func saveCharacters(characters: [Character])
    func getAllCharacters(completion: @escaping ([Character]?) -> Void)
    func getCharacter(characterId: Int64) -> Character?
    func characterExists(characterId: Int64, inContext: NSManagedObjectContext) -> Bool
    func deleteCharacter(characterId: Int64) -> Bool
    func createCharacter(character: Character, inContext: NSManagedObjectContext)
    func deleteAllCharacters() -> Bool
}
