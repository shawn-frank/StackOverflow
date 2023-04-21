
# UICollectionView grid layout

This solution was developed in response to this [StackOverflow question](https://stackoverflow.com/q/76030350/1619193) where the OP wanted to create a grid layout similar to something you would see with TicTacToe. 

This can be achieved using `UICollectionViewDelegateFlowLayout`, specifically `sizeForItemAt indexPath` to set the width and height of each cell.

Depending on the number of columns, the collection view's width must be equally divided among all the cells in the column. Since we are trying to achieve a grid like layout, I assume the height of the cell should be equal to the width.

This is how I calculate the size of each cell:

```
private func getCellSize() -> CGSize {
    let totalHorizontalSpacing = CGFloat(currentColumnCount - 1) * cellSpacing
    
    let cellWidth = (collectionView.bounds.width - totalHorizontalSpacing) / CGFloat(currentColumnCount)
    
    let cellHeight = cellWidth
    
    return CGSize(width: cellWidth, height: cellHeight)
}
```

Download the project to analyse the complete code. This is the end result

https://user-images.githubusercontent.com/80219691/233556952-0b363815-9a4e-4ded-8053-13f9bba6da53.mov

