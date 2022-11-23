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
	private var savedPhotosCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 20
		layout.scrollDirection = .vertical
		let savedPhotosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		savedPhotosCollectionView.isPagingEnabled = true
		savedPhotosCollectionView.backgroundColor = .clear
		savedPhotosCollectionView.translatesAutoresizingMaskIntoConstraints = false
		return savedPhotosCollectionView
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
		savedPhotosCollectionView.register(PhotoManagerCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoManagerCollectionViewCell")
		savedPhotosCollectionView.delegate = self
		savedPhotosCollectionView.dataSource = self
	}

	override func viewWillAppear(_ animated: Bool) {
		savedPhotosCollectionView.reloadData()
	}

	// MARK: Function

	private func createBackground() {
		fonImage.image = UIImage(named: "fon")
		fonImage.contentMode = UIView.ContentMode.scaleAspectFill
		fonImage.alpha = 0.8
		view.backgroundColor = .black
		self.view.insertSubview(fonImage, at: 1)
	}

	private func createExitButton() {
		let exitBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitButtonAction))
		self.navigationItem.leftBarButtonItem = exitBarButtonItem
		navigationController?.navigationBar.tintColor = .white
	}

	@objc private func exitButtonAction() {
		navigationController?.dismiss(animated: true)
	}

	private func addViews() {
		view.addSubview(addPhotoButton)
		view.addSubview(favouriteButton)
		view.addSubview(savedPhotosCollectionView)
	}

	private func setupRecognizers() {
		let addPhotoRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPhotoButtonAction))
		addPhotoButton.addGestureRecognizer(addPhotoRecognizer)
		let favouriteButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(favouriteButtonAction))
		favouriteButton.addGestureRecognizer(favouriteButtonRecognizer)
	}

	@objc private func addPhotoButtonAction() {
		let addPhotoVC = AddPhotoViewController()
		navigationController?.pushViewController(addPhotoVC, animated: true)
	}

	@objc private func favouriteButtonAction() {
		let likePhotoVC = LikePhotosViewController()
		navigationController?.pushViewController(likePhotoVC, animated: true)
	}
	
	private func loadImage(fileName: String) -> UIImage? {
		if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let imageUrl = documentsDirectory.appendingPathComponent(fileName)
			let image = UIImage(contentsOfFile: imageUrl.path)
			return image
		}
		return nil
	}

	private func setupConstraints() {
		let buttonSize: CGFloat = 40
		let space: CGFloat = 20
		NSLayoutConstraint.activate(
			[
				addPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space),
				addPhotoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -space),
				addPhotoButton.heightAnchor.constraint(equalToConstant: buttonSize),
				addPhotoButton.widthAnchor.constraint(equalToConstant: buttonSize),

				favouriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space),
				favouriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -space),
				favouriteButton.heightAnchor.constraint(equalToConstant: buttonSize),
				favouriteButton.widthAnchor.constraint(equalToConstant: buttonSize),

				savedPhotosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space),
				savedPhotosCollectionView.bottomAnchor.constraint(equalTo: favouriteButton.topAnchor, constant: -space),
				savedPhotosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space),
				savedPhotosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space)

			]
		)
	}
}

extension PhotoManagerViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let likePhotoVC = LikePhotosViewController()
		likePhotoVC.startIndexPath = indexPath
		navigationController?.pushViewController(likePhotoVC, animated: true)
	}
}

extension PhotoManagerViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		storage.photos.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoManagerCollectionViewCell", for: indexPath) as? PhotoManagerCollectionViewCell else { return UICollectionViewCell()}
		if let imageName = storage.photos[indexPath.row].imageName,
		   let image = loadImage(fileName: imageName) {
			cell.configure(image: image)
		}
		return cell
	}
}
extension PhotoManagerViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let side = (collectionView.frame.size.width - 30) / 2
		return CGSize(width: side, height: side)

	}
}
