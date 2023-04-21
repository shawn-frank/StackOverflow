//
//  ViewController.swift
//  CollectionViewGrid
//
//  Created by Shawn Frank on 17/4/2023.
//

import UIKit

class ViewController: UIViewController {

    private let minColumnCount = 1
    private let maxColumnCount = 5
    
    private let minRowCount = 1
    private let maxRowCount = 5
    
    private var currentColumnCount = 1
    private var currentRowCount = 1
    
    // We only want the slider value to reflect whole numbers
    private let step: Float = 1
    
    @IBAction func columnSliderDidChange(_ sender: UISlider) {
        currentColumnCount = Int(round(sender.value / step) * step)
    }
    
    
    @IBAction func rowSliderDidChange(_ sender: UISlider) {
        currentRowCount = Int(round(sender.value / step) * step)
    }
    
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVCell.cellIdentifier,
                                                            for: indexPath) as? CVCell else {
            return UICollectionViewCell()
        }
        
        cell.cellButton.setTitle("Button \(indexPath.item + 1)", for: .normal)
        return cell
    }
}

