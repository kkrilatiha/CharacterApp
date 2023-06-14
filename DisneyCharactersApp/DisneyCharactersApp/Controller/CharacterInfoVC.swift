//
//  CharacterDetailsVC.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 09/06/2023.
//

import Foundation
import UIKit


class CharacterInfoVC: UIViewController {
    
    static let CharacterInfoIdentifier = "CharacterInfoVC"
    var viewModel: CharactersInfoViewModel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func label(_ text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    private func configure() {
        
        viewModel.iconForCharacter { image, error in
            if let imageObject = image {
                DispatchQueue.main.async {
                    self.iconImageView.image = imageObject
                }
            }
        }
        
        [label("Name: \(viewModel.character.name)"),
         label("Films: \(viewModel.character.films.joined(separator:" | "))"),
         label("Enemies: \(viewModel.character.enemies.joined(separator:" | "))"),
         label("Allies: \(viewModel.character.allies.joined(separator:" | "))"),
         label("Park Attractions: \(viewModel.character.parkAttractions.joined(separator:" | "))"),
         label("Short Films: \(viewModel.character.shortFilms.joined(separator:" | "))"),
         label("Video Games: \(viewModel.character.tvShows.joined(separator:" | "))")
         
        ].forEach { detailsStackView.addArrangedSubview($0) }
    }
}
