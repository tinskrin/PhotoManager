//
//  PhotoStorage.swift
//  Photo Manager
//
//  Created by Kris on 02.10.2022.
//

import Foundation

final class PhotoStorage {

	static let shared = PhotoStorage()

	private (set) var photos: [PhotoViewModel] = []

	private init() {
		if let photo = UserDefaults.standard.object(forKey: "photos") as? Data,
		   let value = try? JSONDecoder().decode([PhotoViewModel].self, from: photo) {
			self.photos = value
		}
	}

	func saved(photoName: String, text: String) {
		photos.append(PhotoViewModel(imageName: photoName, text: text))
		updateValue()
	}

	func updateValue() {
		if let photo = try? JSONEncoder().encode(photos) {
			UserDefaults.standard.set(photo, forKey: "photos")
		}
	}
}
