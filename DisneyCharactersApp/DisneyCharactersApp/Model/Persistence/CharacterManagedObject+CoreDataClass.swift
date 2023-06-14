//
//  CharacterManagedObject+CoreDataClass.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 13/06/2023.
//
//

import Foundation
import CoreData


protocol ModelObjectTransformable {
    associatedtype ModelObject
    func toModelObject() -> ModelObject
}

@objc(CharacterManagedObject)
public class CharacterManagedObject: NSManagedObject {

}

extension CharacterManagedObject: ModelObjectTransformable {

    func toModelObject() -> Character {
        return Character(characterId: characterId,
                         name: name ?? "",
                         imageUrl: imageUrl ?? "",
                         allies: allies ?? [],
                         enemies: enemies ?? [],
                         films: films ?? [],
                         parkAttractions: parkAttractions ?? [],
                         shortFilms: shortFilms ?? [],
                         tvShows: tvShows ?? [],
                         videoGames: videoGames ?? [])
    }
}
