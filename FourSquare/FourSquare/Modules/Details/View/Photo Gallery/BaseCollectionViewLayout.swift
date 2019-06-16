//
//  BaseCollectionViewLayout.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 09/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

class BaseCollectionViewLayout: UICollectionViewLayout {
    private var _layoutMap = [IndexPath : UICollectionViewLayoutAttributes]()
    private var _columnsYoffset: [CGFloat]!
    private var _contentSize: CGSize = CGSize(width: 0, height: 0)
    
    private(set) var totalItemsInSection = 0
    
    var totalColumns = 0
    var interItemsSpacing: CGFloat = 8
    
    var contentInsets: UIEdgeInsets {
        return collectionView!.contentInset
    }
    
    override var collectionViewContentSize: CGSize {
        return _contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        
        for (_, layoutAttributes) in _layoutMap {
            if rect.intersects(layoutAttributes.frame) {
                layoutAttributesArray.append(layoutAttributes)
            }
        }
        
        return layoutAttributesArray
    }
    
    override func prepare() {
        _layoutMap.removeAll()
        _columnsYoffset = Array(repeating: 0, count: totalColumns)
        
        totalItemsInSection = collectionView!.numberOfItems(inSection: 0)

        if totalItemsInSection > 0 && totalColumns > 0 {
            calculateItemsSize()
            
            var itemIndex = 0
            var contentSizeHeight: CGFloat = 0
            
            while itemIndex < totalItemsInSection {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let columnIndex = columnIndexForItemAt(indexPath: indexPath)

                let attributeRect = calculateItemFrame(indexPath: indexPath, columnIndex: columnIndex, columnYoffset: _columnsYoffset[columnIndex])
                let targetLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                targetLayoutAttributes.frame = attributeRect

                contentSizeHeight = max(attributeRect.maxY, contentSizeHeight)
                _columnsYoffset[columnIndex] = attributeRect.maxY + interItemsSpacing
                _layoutMap[indexPath] = targetLayoutAttributes
                
                itemIndex += 1
            }

            _contentSize = CGSize(width: collectionView!.bounds.width - contentInsets.left - contentInsets.right,
                                  height: contentSizeHeight)
        }
    }
    
    func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        return indexPath.item % totalColumns
    }

    func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        return CGRect.zero
    }

    func calculateItemsSize() {}
}
