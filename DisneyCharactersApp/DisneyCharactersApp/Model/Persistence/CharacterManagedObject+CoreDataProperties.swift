//
//  CharacterManagedObject+CoreDataProperties.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 13/06/2023.
//
//

import Foundation
import CoreData


extension CharacterManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterManagedObject> {
        return NSFetchRequest<CharacterManagedObject>(entityName: "Character")
    }

    @NSManaged public var allies: [String]?
    @NSManaged public var characterId: Int64
    @NSManaged public var enemies: [String]?
    @NSManaged public var films: [String]?
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var parkAttractions: [String]?
    @NSManaged public var shortFilms: [String]?
    @NSManaged public var tvShows: [String]?
    @NSManaged public var videoGames: [String]?

}

extension CharacterManagedObject : Identifiable {

}
