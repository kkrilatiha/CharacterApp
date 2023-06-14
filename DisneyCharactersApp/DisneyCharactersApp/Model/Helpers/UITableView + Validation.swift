//
//  UITableView + Validation.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 09/06/2023.
//

import Foundation
import UIKit


extension UITableView {

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
