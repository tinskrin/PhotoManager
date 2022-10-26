//
//  PhotoViewModel.swift
//  Photo Manager
//
//  Created by Kris on 02.10.2022.
//

import Foundation


class PhotoViewModel: Codable {
	var imageName: String?
	var text: String?
	var isLiked: Bool = false

	init(
		imageName: String = "",
		text: String = "",
		isLiked: Bool = false
	) {
		self.imageName = imageName
		self.text = text
		self.isLiked = isLiked
	}
}
