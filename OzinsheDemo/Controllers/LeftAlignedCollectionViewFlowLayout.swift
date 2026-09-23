//
//  LeftAlignedCollectionViewFlowLayout.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 04.09.2026.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // Make deep copies to avoid mutating cached attributes directly
        guard let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else {
            return superAttributes
        }

        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0

        for layoutAttribute in attributes {
            guard layoutAttribute.representedElementCategory == .cell else { continue }

            // If we move to a new row, reset left margin
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return attributes
    }
}
