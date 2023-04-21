//
//  CVCell.swift
//  CollectionViewGrid
//
//  Created by Shawn Frank on 21/4/2023.
//

import UIKit

class CVCell: UICollectionViewCell {
    static let cellIdentifier = "cvcell"
    
    @IBOutlet weak var cellButton: UIButton!
    
    @IBAction func cellButtonTapped(_ sender: UIButton) {
        print("tapped button: \(sender.titleLabel?.text ?? "")")
    }
}
