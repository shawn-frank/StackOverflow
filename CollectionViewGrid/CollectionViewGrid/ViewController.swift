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
    
    private let cellSpacing: CGFloat = 1
    
    private var currentColumnCount = 1
    private var currentRowCount = 1
    
    // We only want the slider value to reflect whole numbers
    private let step: Float = 1
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func columnSliderDidChange(_ sender: UISlider) {
        currentColumnCount = Int(round(sender.value / step) * step)
    }
    
    
    @IBAction func rowSliderDidChange(_ sender: UISlider) {
        currentRowCount = Int(round(sender.value / step) * step)
    }
    
    private func getCellSize() -> CGSize {
        let totalHorizontalSpacing = CGFloat(currentColumnCount - 1) * cellSpacing
        
        let cellWidth = (collectionView.bounds.width - totalHorizontalSpacing) / CGFloat(currentColumnCount)
        
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return currentRowCount * currentColumnCount
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

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize()
    }
}

