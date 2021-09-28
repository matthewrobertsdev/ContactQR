//
//  ColorsCollectionViewExtension.swift
//  Contact Cards
//
//  Created by Matt Roberts on 9/28/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
extension CreateContactViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width  = 27.5
		let height=width
		return CGSize(width: width, height: height)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		let totalCellWidth = 27.5 * Float(collectionView.numberOfItems(inSection: 0))
		let totalSpacingWidth = 2 * Float(collectionView.numberOfItems(inSection: 0) - 1)

		let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
		let rightInset = leftInset

		return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return colorModel.colors.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "SelectColorCell", for: indexPath) as? SelectColorCell else {
			return UICollectionViewCell()
		}
		let color=colorModel.colors[indexPath.row]
		cell.circularColorView.backgroundColor=color.color
		cell.isAccessibilityElement=true
		cell.accessibilityLabel=color.name
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let index=indexPath.item
		titleTextField.textColor=colorModel.colors[index].color
	}
}
