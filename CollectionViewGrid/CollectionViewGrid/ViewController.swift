//
//  ViewController.swift
//  CollectionViewGrid
//
//  Created by Shawn Frank on 17/4/2023.
//

import UIKit

class ViewController: UIViewController {

    private let minColumnCount = 1
    private let maxColumnCount = 4
    
    private let minRowCount = 1
    private let maxRowCount = 4
    
    private let cellSpacing: CGFloat = 1
    
    private var currentColumnCount = 1 {
        didSet {
            updateUI()
        }
    }
    
    private var currentRowCount = 1 {
        didSet {
            updateUI()
        }
    }
    
    // We only want the slider value to reflect whole numbers
    // https://stackoverflow.com/a/6372184/1619193
    private let step: Float = 1
    
    @IBOutlet weak var buttonTappedLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var currentColumnsLabel: UILabel!
    
    @IBOutlet weak var currentRowsLabel: UILabel!
    
    @IBAction func columnSliderDidChange(_ sender: UISlider) {
        let newStep = roundf((sender.value) / step);
        currentColumnCount = Int(newStep * step)
        sender.value = newStep * step
    }
    
    
    @IBAction func rowSliderDidChange(_ sender: UISlider) {
        let newStep = roundf((sender.value) / step);
        currentRowCount = Int(newStep * step)
        sender.value = newStep * step
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didTapCVCellButton(_:)),
                                               name: .collectionViewButtonTapNotificationName,
                                               object: nil)
    }
    
    @objc private func didTapCVCellButton(_ notification: Notification) {
        if let buttonLabel = notification.object as? String {
            buttonTappedLabel.text = "Button \(buttonLabel) tapped"
        }
    }
    
    private func updateUI() {
        currentColumnsLabel.text = "Columns: \(currentColumnCount)"
        currentRowsLabel.text = "Rows: \(currentRowCount)"
        collectionView.reloadData()
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
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize()
    }
}

