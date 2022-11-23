//
//  PhotoManagerCollectionViewCell.swift
//  Photo Manager
//
//  Created by Kris on 02.11.2022.
//

import UIKit

class PhotoManagerCollectionViewCell: UICollectionViewCell {

	weak var photoDelegate: LikePhotoDelegate?

	private let mainImageView: UIImageView = {
		let mainImageView = UIImageView()
		mainImageView.translatesAutoresizingMaskIntoConstraints = false
		return mainImageView
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(image: UIImage) {
		mainImageView.image = image
	}

	private func setupView() {
		addSubview(mainImageView)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate(
			[
				mainImageView.topAnchor.constraint(equalTo: topAnchor),
				mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
				mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
				mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

			]
		)
	}
	
}
