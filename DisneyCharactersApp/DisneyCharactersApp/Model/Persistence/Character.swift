//
//  Character.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 09/06/2023.
//

import Foundation
import CoreData

protocol ManagedObjectTransformable {
    associatedtype ManagedObject
    func toManagedObject(inContext: NSManagedObjectContext) -> ManagedObject?
}


public struct Character: Codable {

    enum CodingKeys: String, CodingKey {
        case allies
        case characterId = "_id"
        case enemies
        case films
        case imageUrl
        case name
        case parkAttractions
        case shortFilms
        case tvShows
        case videoGames
    }
    
    public var characterId: Int64
    public let name: String
    public let imageUrl: String
    public let allies: [String]
    public let enemies: [String]
    public let films: [String]
    public let parkAttractions: [String]
    public let shortFilms: [String]
    public let tvShows: [String]
    public let videoGames: [String]
    
    init(characterId: Int64,
         name: String,
         imageUrl: String,
         allies: [String],
         enemies: [String],
         films: [String],
         parkAttractions: [String],
         shortFilms: [String],
         tvShows: [String],
         videoGames: [String]) {
        
        self.characterId = characterId
        self.name = name
        self.imageUrl = imageUrl
        self.allies = allies
        self.enemies = enemies
        self.films = films
        self.parkAttractions = parkAttractions
        self.shortFilms = shortFilms
        self.tvShows = tvShows
        self.videoGames = videoGames
    }
}


extension Character: ManagedObjectTransformable {
    
    func toManagedObject(inContext: NSManagedObjectContext) -> CharacterManagedObject? {
        
        guard let entityName = CharacterManagedObject.entity().name else {
            NSLog("Can't create entity, name is nil.")
            return nil
        }
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: inContext) else {
            NSLog("Can't create entity \(entityName)")
            return nil
        }
        
        return managedObjectWith(entity: entityDescription, inContext: inContext)
    }
    
    
    private func managedObjectWith(entity: NSEntityDescription, inContext: NSManagedObjectContext) -> CharacterManagedObject {
        let object = CharacterManagedObject(context: inContext)

        object.characterId = characterId
        object.imageUrl = imageUrl
        object.name = name
        object.allies = allies
        object.enemies = enemies
        object.films = films
        object.parkAttractions = parkAttractions
        object.shortFilms = shortFilms
        object.tvShows = tvShows
        object.videoGames = videoGames
        
        return object
    }
    
    var dictionary: [String: Any] {
       return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
