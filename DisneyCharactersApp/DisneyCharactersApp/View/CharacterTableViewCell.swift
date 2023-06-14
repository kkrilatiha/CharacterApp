//
//  CharacterTableViewCell.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 07/06/2023.
//

import Foundation
import UIKit


class CharacterTableViewCell : UITableViewCell {
    
    @IBOutlet weak var filmsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    static let cellIdentifier = "CharacterCellIdentifier"
    static let nibName = "CharacterTableViewCell"
    
    override func prepareForReuse() {
            super.prepareForReuse()
            iconImageView.image = nil
        }
    
    public func reloadCharacter(withModel: CharactersInfoViewModel) {
        nameLabel?.text = withModel.character.name
        filmsLabel?.text = withModel.character.films.joined(separator:" | ")
       
        withModel.iconForCharacter { image, error in
            if let imageObject = image {

                DispatchQueue.main.async {
                    self.iconImageView.image = imageObject
                }
            }
        }
    }
}
