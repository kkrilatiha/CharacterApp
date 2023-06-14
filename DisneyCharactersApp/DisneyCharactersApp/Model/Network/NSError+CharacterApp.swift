//
//  NSError + CharacterApp.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 13/06/2023.
//

import Foundation


public enum ErrorType: Int {
    
    case URLFailure = 1
    case ServiceUnavailable = 2
    case NoDataProvided = 3
    case ImageFromDataFailure = 4
    
    func localizedUserInfo() -> [String: String] {
        var localizedDescription: String = ""
        
        switch self {
        case .URLFailure:
            localizedDescription = NSLocalizedString("Error.URLFailure", comment: "URL failure")
        case .ServiceUnavailable:
            localizedDescription = NSLocalizedString("Error.ServiceUnavailable", comment: "Can't load data. Service unavailable.")
        case .NoDataProvided:
            localizedDescription = NSLocalizedString("Error.NoDataProvided", comment: "No data available.")
        case .ImageFromDataFailure:
            localizedDescription = NSLocalizedString("Error.ImageFromDataFailure", comment: "No image available.")
        }
        return [
            NSLocalizedDescriptionKey: localizedDescription
        ]
    }
}

public let ProjectErrorDomain = "CharacterAppErrorDomain"

extension NSError {
    
    public convenience init(type: ErrorType) {
        self.init(domain: ProjectErrorDomain, code: type.rawValue, userInfo: type.localizedUserInfo())
    }
}
