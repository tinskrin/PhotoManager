//
//  SavedPhotosCollectionViewCell.swift
//  Photo Manager
//
//  Created by Kris on 23.10.2022.
//

import UIKit

class SavedPhotosCollectionViewCell: UICollectionViewCell {

	static let reuseId = "SavedPhotosCollectionViewCell"

	let mainImageView: UIImageView = {
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

	private func setupView() {
		contentView.addSubview(mainImageView)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate(
			[
				mainImageView.topAnchor.constraint(equalTo: super.topAnchor),
				mainImageView.leadingAnchor.constraint(equalTo: super.leadingAnchor),
				mainImageView.trailingAnchor.constraint(equalTo: super.trailingAnchor),
				mainImageView.bottomAnchor.constraint(equalTo: super.bottomAnchor)

			]
		)
	}
}
