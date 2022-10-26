//
//  AddPhotoViewController.swift
//  Photo Manager
//
//  Created by Kris on 28.09.2022.
//

import Foundation
import UIKit

class AddPhotoViewController: UIViewController {
	
	private let fonImage = UIImageView(frame: UIScreen.main.bounds)

	private let addedImageView: UIImageView = {
		let addedImageView = UIImageView()
		addedImageView.translatesAutoresizingMaskIntoConstraints = false
		return addedImageView
	}()

	private let commentField: UITextView = {
		let commentField = UITextView()
		commentField.translatesAutoresizingMaskIntoConstraints = false
		commentField.backgroundColor = UIColor(red: 0.16, green: 0.27, blue: 0.99, alpha: 1.00).withAlphaComponent(0.3)
		commentField.text = "Write your comment"
		commentField.textColor = .lightGray
		return commentField
	}()
	private let addAndEditButton: UIButton = {
		let addAndEditButton = UIButton()
		let buttonImage = UIImage(named: "plus")?.withTintColor(.white)
		addAndEditButton.setImage(buttonImage, for: .normal)
		addAndEditButton.translatesAutoresizingMaskIntoConstraints = false
		return addAndEditButton
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupBackground()
		setupViews()
		setupConstraints()
		setupRecognizers()
	}

	private func presentAlert(title: String, message: String, shouldCloseVC: Bool = false) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
			if shouldCloseVC {
				self?.navigationController?.popViewController(animated: true)
			}
		}
		alert.addAction(action)
		self.present(alert, animated: true)
	}

	private func updateEditImage() {
		if addedImageView.image == nil {
			addAndEditButton.setImage(UIImage(named: "plus")?.withTintColor(.white), for: .normal)
		} else {
			addAndEditButton.setImage(UIImage(named: "pencil")?.withTintColor(.white), for: .normal)
		}
	}

	// MARK: - Actions

	@objc private func addButtonAction() {
		let picker = UIImagePickerController()
		picker.sourceType = .photoLibrary
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true, completion: nil)
	}

	@objc private func saveButtonPressed() {
		if addedImageView.image == nil || commentField.text == "Write your comment" {
			presentAlert(title: "Error", message: "Image or comment can not be empty")
		}
		guard let data = addedImageView.image?.jpegData(compressionQuality: 1) else { return }
		let photoName = NSUUID().uuidString.lowercased().appending(".jpeg")
		let photoPath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
			.appendingPathComponent(photoName)
		do {
			try data.write(to: photoPath!)
			PhotoStorage.shared.saved(photoName: photoName, text: commentField.text)
			presentAlert(title: "Success", message: "Your image was saved", shouldCloseVC: true)

		} catch let error {
			print("Error saving file with error", error)
		}
	}

	@objc func tap(sender: UITapGestureRecognizer) {
		if commentField.isFirstResponder {
			commentField.resignFirstResponder()
		}
	}


	// MARK: - Setup

	private func setupRecognizers() {
		let addImageButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(addButtonAction))
		addAndEditButton.addGestureRecognizer(addImageButtonRecognizer)
		let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(tap))
		view.addGestureRecognizer(tapGestureRecogniser)
	}

	private func setupBackground() {
		fonImage.image = UIImage(named: "fon")
		fonImage.contentMode = UIView.ContentMode.scaleAspectFill
		fonImage.alpha = 0.8
		view.backgroundColor = .black
		self.view.insertSubview(fonImage, at: 1)
	}

	private func setupViews() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed))
		view.addSubview(commentField)
		view.addSubview(addedImageView)
		view.addSubview(addAndEditButton)
		commentField.delegate = self
	}

	private func setupConstraints() {
		let intervalSize: CGFloat = 30
		let addAndEditButtonSize: CGFloat = 30
		NSLayoutConstraint.activate(
			[
				addedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: intervalSize),
				addedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -intervalSize),
				addedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: intervalSize),
				addedImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 3),

				commentField.topAnchor.constraint(equalTo: addedImageView.bottomAnchor, constant: 20),
				commentField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: intervalSize),
				commentField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -intervalSize),
				commentField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.frame.height / 3),

				addAndEditButton.trailingAnchor.constraint(equalTo: addedImageView.trailingAnchor, constant: -intervalSize/2),
				addAndEditButton.topAnchor.constraint(equalTo: addedImageView.topAnchor, constant: intervalSize),
				addAndEditButton.heightAnchor.constraint(equalToConstant: addAndEditButtonSize),
				addAndEditButton.widthAnchor.constraint(equalToConstant: addAndEditButtonSize)
			]
		)
	}
}


extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true, completion: nil)
		var choosenImage: UIImage?

		if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
			choosenImage = image
		} else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			choosenImage = image
		}
		addedImageView.image = choosenImage
		updateEditImage()
	}
}


extension AddPhotoViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ commentField: UITextView) {
		if commentField.textColor == .lightGray {
			commentField.text = nil
			commentField.textColor = .white
		}
	}

	func textViewDidEndEditing(_ commentField: UITextView) {
		if commentField.text.isEmpty {
			commentField.text = "Write your comment"
			commentField.textColor = .lightGray
		}
	}
}
