//
//  PhotoManagerViewController.swift
//  Photo Manager
//
//  Created by Kris on 28.09.2022.
//

import Foundation
import UIKit

class PhotoManagerViewController: UIViewController {

	private let fonImage = UIImageView(frame: UIScreen.main.bounds)

	private let addPhotoButton: UIButton = {
		let addPhotoButton = UIButton()
		let addPhotoImage = UIImage(named: "plus")?.withTintColor(.white)
		addPhotoButton.setImage(addPhotoImage, for: .normal)
		addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
		return addPhotoButton
	}()
	private let favouriteButton: UIButton = {
		let favouriteButton = UIButton()
		let favouritePhotoImage = UIImage(named: "heart")?.withTintColor(.white)
		favouriteButton.setImage(favouritePhotoImage, for: .normal)
		favouriteButton.translatesAutoresizingMaskIntoConstraints = false
		return favouriteButton
	}()

	private let storage = PhotoStorage.shared

	// MARK: LifeCycle

	override func viewDidLoad() {
		super.viewDidLoad()
		createBackground()
		createExitButton()
		addViews()
		setupConstraints()
		setupRecognizers()
		title = "Photo Manager"
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
	}

	// MARK: Function

	private func createBackground(){
		fonImage.image = UIImage(named: "fon")
		fonImage.contentMode = UIView.ContentMode.scaleAspectFill
		fonImage.alpha = 0.8
		view.backgroundColor = .black
		self.view.insertSubview(fonImage, at: 1)
	}

	private func createExitButton(){
		let exitBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitButtonAction))
		self.navigationItem.leftBarButtonItem = exitBarButtonItem
		navigationController?.navigationBar.tintColor = .white
	}

	@objc private func exitButtonAction(){
		navigationController?.dismiss(animated: true)
	}

	private func addViews(){
		view.addSubview(addPhotoButton)
		view.addSubview(favouriteButton)
	}

	private func setupRecognizers(){
		let addPhotoRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPhotoButtonAction))
		addPhotoButton.addGestureRecognizer(addPhotoRecognizer)
		let favouriteButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(favouriteButtonAction))
		favouriteButton.addGestureRecognizer(favouriteButtonRecognizer)
	}

	@objc private func addPhotoButtonAction(){
		let addPhotoVC = AddPhotoViewController()
		navigationController?.pushViewController(addPhotoVC, animated: true)
	}

	@objc private func favouriteButtonAction(){
		let likePhotoVC = LikePhotosViewController()
		navigationController?.pushViewController(likePhotoVC, animated: true)
	}

	private func setupConstraints(){
		let buttonSize: CGFloat = 40
		NSLayoutConstraint.activate(
			[
				addPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
				addPhotoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
				addPhotoButton.heightAnchor.constraint(equalToConstant: buttonSize),
				addPhotoButton.widthAnchor.constraint(equalToConstant: buttonSize),

				favouriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
				favouriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
				favouriteButton.heightAnchor.constraint(equalToConstant: buttonSize),
				favouriteButton.widthAnchor.constraint(equalToConstant: buttonSize)

			]
		)
	}
}
