//
//  FileDataManager.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 09/06/2023.
//

import Foundation
import UIKit


protocol CachingManager {
    func cacheImage(_ image: UIImage, forKey: URL)
    func cachedImage(forKey: URL) -> UIImage?
}

class ImageManager {
    
    static let shared = ImageManager()
    private let cachedImages = NSCache<AnyObject, UIImage>()
    
    
    func cacheImage(_ image: UIImage, forKey: URL) {
        self.cachedImages.setObject(image, forKey: forKey as AnyObject)
    }
    
    func cachedImage(forKey: URL) -> UIImage? {
        return cachedImages.object(forKey: forKey as AnyObject)
    }

}
