//
//  CharactersVC.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 07/06/2023.
//

import Foundation
import UIKit




class CharactersVC : UITableViewController {
    
    private var viewModel: AllCharactersViewModel!
    static let CharacterVCIdentifier = "CharactersVC"
    
    init(viewModel: AllCharactersViewModel){
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTable()
        loadCharacters()
    }
    
    // MARK: - Private methods
    
    private func loadCharacters() {
        
        viewModel.getAllCharacters { success, error in
            
            DispatchQueue.main.async {
                if success == false, let error = error {
                    
                    let alert = UIAlertController(title: "Disney Characters",
                                                  message: error.localizedDescription,
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    private func prepareTable() {
        let nib = UINib.init(nibName: CharacterTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CharacterTableViewCell.cellIdentifier)
        tableView.rowHeight = 140.0
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func modelForIndexPath(_ indexPath: IndexPath) -> CharactersInfoViewModel? {
        guard indexPath.row >= 0 && indexPath.row < viewModel.characters.count else {
            return nil
        }
        let character = viewModel.characters[indexPath.row]
        return CharactersInfoViewModel(character: character)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.characters.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.cellIdentifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        let character = viewModel.characters[indexPath.row]
        cell.reloadCharacter(withModel: CharactersInfoViewModel(character: character))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let charactersVC : CharacterInfoVC = storyboard.instantiateViewController(withIdentifier: CharacterInfoVC.CharacterInfoIdentifier) as? CharacterInfoVC else {
            return
        }
        
        let character = viewModel.characters[indexPath.row]
        let infoModel = CharactersInfoViewModel(character: character)
        charactersVC.viewModel = infoModel
        self.navigationController?.pushViewController(charactersVC, animated: true)
    }
}

