//
//  LikePhotosViewController.swift
//  Photo Manager
//
//  Created by Kris on 28.09.2022.
//

import Foundation
import UIKit

protocol LikePhotoDelegate: AnyObject {
	var viewModelsCount: Int { get }
	func viewModelForItemAt(_ indexPath: IndexPath) -> PhotoViewModel
	func cellWasChangeTo(_ index: Int)
}

class LikePhotosViewController: UIViewController {

	var startIndexPath: IndexPath?
	private let fonImage = UIImageView(frame: UIScreen.main.bounds)
	private var viewModels: [PhotoViewModel] = PhotoStorage.shared.photos
	private var currentViewModel: PhotoViewModel = .init()
	private let commentField: UITextView = {
		let commentField = UITextView()
		commentField.translatesAutoresizingMaskIntoConstraints = false
		commentField.textColor = .white
		commentField.backgroundColor = UIColor(red: 0.16,
											   green: 0.27,
											   blue: 0.99,
											   alpha: 1.00)
		.withAlphaComponent(0.3)
		return commentField
	}()

	private var savedPhotosCollectionView: SavedPhotosCollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.scrollDirection = .horizontal
		let view = SavedPhotosCollectionView(frame: .zero, collectionViewLayout: layout)
		view.isPagingEnabled = true
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		createBackground()
		addViews()
		setupConstraints()
		setupView()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let startIndexPath = startIndexPath {
			savedPhotosCollectionView.scrollToItem(at: startIndexPath, at: .centeredHorizontally, animated: true)
			commentField.text = viewModels[startIndexPath.row].text
		}
	}

	@objc func tap(sender: UITapGestureRecognizer) {
		if commentField.isFirstResponder {
			commentField.resignFirstResponder()
		}
	}
	
	private func setupView() {
		if viewModels.isEmpty {
			commentField.isHidden = true
			presentAlert()
		}
		cellWasChangeTo(0)
		commentField.delegate = self
		savedPhotosCollectionView.photoDelegate = self
		let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(tap))
		view.addGestureRecognizer(tapGestureRecogniser)
	}

	private func createBackground() {
		fonImage.image = UIImage(named: "fon")
		fonImage.contentMode = UIView.ContentMode.scaleAspectFill
		fonImage.alpha = 0.8
		view.backgroundColor = .black
		self.view.insertSubview(fonImage, at: 1)
	}

	private func addViews(){
		view.addSubview(savedPhotosCollectionView)
		view.addSubview(commentField)
	}

	private func setupConstraints() {
		let space: CGFloat = 20
		NSLayoutConstraint.activate(
			[
				savedPhotosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
				savedPhotosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
				savedPhotosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space),
				savedPhotosCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 3),

				commentField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space),
				commentField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space),
				commentField.topAnchor.constraint(equalTo: savedPhotosCollectionView.bottomAnchor, constant: space),
				commentField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 3 )
			]
		)
	}

	private func presentAlert() {
		let alert = UIAlertController(title: "Sorry", message: "You should add photo before", preferredStyle: .alert)
		let action = UIAlertAction(title: "Back", style: .cancel) { [weak self] _ in
			self?.navigationController?.popViewController(animated: true)
		}
		alert.addAction(action)
		self.present(alert, animated: true)
	}
}

extension LikePhotosViewController: LikePhotoDelegate {
	func cellWasChangeTo(_ index: Int) {
		guard !viewModels.isEmpty else { return }
		commentField.text = viewModels[index].text
		currentViewModel = viewModels[index]
	}

	func viewModelForItemAt(_ indexPath: IndexPath) -> PhotoViewModel {
		viewModels[indexPath.row]
	}

	var viewModelsCount: Int {
		viewModels.count
	}
}

extension LikePhotosViewController: UITextViewDelegate {
	func textViewDidEndEditing(_ textView: UITextView) {
		currentViewModel.text = textView.text
		PhotoStorage.shared.updateValue()
	}
}
