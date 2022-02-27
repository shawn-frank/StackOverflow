//
//  HorizontalLayout.swift
//  CustomCollectionViewLayout
//
//  Created by Shawn Frank on 27/02/2022.
//

import UIKit

class HorizontalLayout: UICollectionViewLayout
{
    // Cache layout attributes for the cells
    private var cellLayoutCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    // Cache layout attributes for the header
    private var headerLayoutCache: [Int: UICollectionViewLayoutAttributes] = [:]
    
    // Set a y offset so the items render a bit lower which
    // leaves room for the title at the top
    private var sectionTitleHeight = CGFloat(60)
    
    // The content height of the layout is static since we're configuring horizontal
    // layout. However, the content width needs to be calculated and returned later
    private var contentWidth = CGFloat.zero
    
    private var contentHeight: CGFloat
    {
        guard let collectionView = collectionView else { return 0 }
        
        let insets = collectionView.contentInset
        
        return collectionView.bounds.height - (insets.left + insets.right)
    }
    
    // Based on the height of the collection view, the interItem spacing and
    // the item height, we can set
    private var maxItemsInRow = 0
    
    // Set the spacing between items & sections
    var itemSpacing: CGFloat = .zero
    var sectionSpacing: CGFloat = .zero
    
    var itemSize: CGSize = .zero
    
    override init()
    {
        super.init()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    // This function gets called before the collection view starts the layout process
    // load layout into the cache so it doesn't have to be recalculated each time
    override func prepare()
    {
        guard let collectionView = collectionView else { return }
        
        // Only calculate if the cache is empty
        guard cellLayoutCache.isEmpty else { return }
        
        updateMaxItemsInRow()
        
        let sections = 0 ... collectionView.numberOfSections - 1
        
        // Track the x position of the items being drawn
        var itemX = CGFloat.zero
            
        // Loop through all the sections
        for section in sections
        {
            var itemY = sectionTitleHeight
            var row = 0
            
            let headerFrame = CGRect(x: itemX,
                                     y: 0,
                                     width: widthOfSection(section),
                                     height: sectionTitleHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                              with: IndexPath(item: 0, section: section))
            attributes.frame = headerFrame
            headerLayoutCache[section] = attributes
            
            let itemsInSection = collectionView.numberOfItems(inSection: section)
            
            // Generate valid index paths for all items in the section
            let indexPaths = [Int](0 ... itemsInSection - 1).map
            {
                IndexPath(item: $0, section: section)
            }
            
            // Loop through all index paths and cache all the layout attributes
            // so it can be reused later
            for indexPath in indexPaths
            {
                let itemFrame = CGRect(x: itemX,
                                   y: itemY,
                                   width: itemSize.width,
                                   height: itemSize.height)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = itemFrame
                cellLayoutCache[indexPath] = attributes
                
                contentWidth = max(contentWidth, itemFrame.maxX)
                
                // last item in the section, update the x position
                // to start the next section in a new column and also
                // update the content width to add the section spacing
                if indexPath.item == indexPaths.count - 1
                {
                    itemX += itemSize.width + sectionSpacing
                    contentWidth = max(contentWidth, itemFrame.maxX + sectionSpacing)
                    continue
                }
                
                if row < maxItemsInRow - 1
                {
                    row += 1
                    itemY += itemSize.height + itemSpacing
                }
                else
                {
                    row = 0
                    itemY = sectionTitleHeight
                    itemX += itemSize.width + itemSpacing
                }
            }
        }
    }
    
    // We need to set the content size. Since it is a horizontal
    // collection view, the height will be fixed. The width should be
    // the max X value of the last item in the collection view
    override var collectionViewContentSize: CGSize
    {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // This defines what gets shown in the rect (viewport) the user
    // is currently viewing
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        // Get the attributes that fall in the current view port
        let itemAttributes = cellLayoutCache.values.filter { rect.intersects($0.frame) }
        let headerAttributes = headerLayoutCache.values.filter { rect.intersects($0.frame) }
        
        return itemAttributes + headerAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        return cellLayoutCache[indexPath]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                       at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        return headerLayoutCache[indexPath.section]
    }
    
    // In invalidateLayout(), the layout of the elements will be changing
    // inside the collection view. Here the attribute cache can be reset
    override func invalidateLayout()
    {
        // Reset the attribute cache
        cellLayoutCache = [:]
        headerLayoutCache = [:]
        
        super.invalidateLayout()
    }
    
    // Invalidating the layout means the layout needs to be recalculated from scratch
    // which might need to happen when the orientation changes so we only want to
    // do this when it is necessary since it is expensive
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool
    {
        guard let collectionView = collectionView else { return false }

        return newBounds.height != collectionView.bounds.height
    }
    
    private func updateMaxItemsInRow()
    {
        guard let collectionView = collectionView else { return }
        
        let contentHeight = collectionView.bounds.height
        
        let totalInsets = collectionView.contentInset.top + collectionView.contentInset.bottom
        
        let availableHeight = contentHeight - sectionTitleHeight - totalInsets
        
        var tempItemsInRow = Int(availableHeight / itemSize.height)
        
        // Figure out max items allowed in a row based on spacing settings
        while tempItemsInRow != 0
        {
            // There is 1 gap between 2 items, 2 gaps between 3 items etc
            let totalSpacing = CGFloat(tempItemsInRow - 1) * itemSpacing
            
            let finalHeight = (CGFloat(tempItemsInRow) * itemSize.height) + totalSpacing
            
            if availableHeight < finalHeight
            {
                tempItemsInRow -= 1
                continue
            }
            
            break
        }
        
        maxItemsInRow = tempItemsInRow
    }
    
    private func widthOfSection(_ section: Int) -> CGFloat
    {
        guard let collectionView = collectionView else { return .zero }
        
        let itemsInSection = collectionView.numberOfItems(inSection: section)
        
        let columnsInSection = itemsInSection / maxItemsInRow
        
        // There is 1 gap between 2 items, 2 gaps between 3 items etc
        let totalSpacing = CGFloat(itemsInSection - 1) * itemSpacing
        
        let totalWidth = (CGFloat(columnsInSection) * itemSize.width) + totalSpacing
        
        return totalWidth
    }
    
}

