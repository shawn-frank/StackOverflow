//
//  ViewController.swift
//  CustomCollectionViewLayout
//
//  Created by Shawn Frank on 27/02/2022.
//

import UIKit

class ViewController: UIViewController
{
    private var collectionView: UICollectionView!

    let colors: [UIColor] = [.systemBlue, .orange, .purple]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Custom header"
        view.backgroundColor = .white
        
        configureCollectionView()
    }
    
    private func configureCollectionView()
    {
        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: createLayout())
        
        collectionView.backgroundColor = .lightGray
        
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        // Auto layout config to pin collection view to the edges of the view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.leadingAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                        constant: 0).isActive = true
        
        collectionView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                        constant: 0).isActive = true
        collectionView.trailingAnchor
            
            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                        constant: 0).isActive = true
        
        collectionView.heightAnchor
            .constraint(equalToConstant: 300).isActive = true
    }

    private func createLayout() -> HorizontalLayout
    {
        let customLayout = HorizontalLayout()
        customLayout.itemSpacing = 10
        customLayout.sectionSpacing = 20
        customLayout.itemSize = CGSize(width: 50, height: 50)
        
        return customLayout
    }
}

extension ViewController: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        // random number
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        // random number
        return 8 + section
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier:"cell",
                                 for: indexPath)
        
        cell.backgroundColor = colors[indexPath.section]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize(width: 200, height: 50)
    }
}

extension ViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView
    {
        let header
            = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                              withReuseIdentifier: HeaderView.identifier,
                                                              for: indexPath) as! HeaderView
        
        header.title.text = "Section \(indexPath.section)"
        
        return header
    }
}

