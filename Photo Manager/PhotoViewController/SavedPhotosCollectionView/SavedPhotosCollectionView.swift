//
//  SavedPhotosCollectionView.swift
//  Photo Manager
//
//  Created by Kris on 23.10.2022.
//

import UIKit

class SavedPhotosCollectionView: UICollectionView {

	weak var photoDelegate: LikePhotoDelegate?

	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		delegate = self
		dataSource = self
		register(SavedPhotosCollectionViewCell.self, forCellWithReuseIdentifier: SavedPhotosCollectionViewCell.reuseId)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let modelIndex = Int(scrollView.contentOffset.x / frame.width)
		photoDelegate?.cellWasChangeTo(modelIndex)
	}

	private func loadImage(fileName: String) -> UIImage? {
		if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let imageUrl = documentsDirectory.appendingPathComponent(fileName)
			let image = UIImage(contentsOfFile: imageUrl.path)
			return image
		}
		return nil
	}
}

extension SavedPhotosCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		photoDelegate?.viewModelsCount ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = dequeueReusableCell(withReuseIdentifier: SavedPhotosCollectionViewCell.reuseId, for: indexPath) as! SavedPhotosCollectionViewCell
		if let imageName = photoDelegate?.viewModelForItemAt(indexPath).imageName {
			let image = loadImage(fileName: imageName)
			cell.mainImageView.image = image
		}
		return cell
	}
}

extension SavedPhotosCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: frame.width, height: frame.height)
	}
}
