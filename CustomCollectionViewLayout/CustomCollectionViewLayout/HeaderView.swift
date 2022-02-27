//
//  HeaderView.swift
//  CustomCollectionViewLayout
//
//  Created by Shawn Frank on 27/02/2022.
//

import UIKit

class HeaderView: UICollectionReusableView
{
    let title = UILabel()
    
    static let identifier = "CVHeader"
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        layoutInterface()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        layoutInterface()
    }

    func layoutInterface()
    {
        backgroundColor = .clear
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.textAlignment = .left
        title.textColor = .black
        addSubview(title)
        
        addConstraints([
        
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
}
