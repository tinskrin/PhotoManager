//
//  StartViewController.swift
//  Photo Manager
//
//  Created by Kris on 26.09.2022.
//

import UIKit

protocol StartViewControllerProtocol: AnyObject {
	func newAccountWasRegister(username: String, password: String)
}

class StartViewController: UIViewController {

	private let fonImage = UIImageView(frame: UIScreen.main.bounds)
	private let accountManager = AccountManager.shared

	private let hiLabel: UILabel = {
		let hiLabel = UILabel()
		hiLabel.translatesAutoresizingMaskIntoConstraints = false
		hiLabel.text = "Photo Manager"
		hiLabel.numberOfLines = 0
		hiLabel.textAlignment = .center
		hiLabel.font = UIFont(name: "ChalkboardSE-Regular" , size: 25)
		hiLabel.textColor = .white
		return hiLabel
	}()
	private let seepasswordButton: UIButton = {
		let seepasswordButton = UIButton()
		let passwordImage = UIImage(named: "eye")?.withTintColor(.white)
		seepasswordButton.setImage(passwordImage, for: .normal)
		seepasswordButton.translatesAutoresizingMaskIntoConstraints = false
		return seepasswordButton
	}()
	private let registerStackiew: UIStackView = {
		let registerStackiew = UIStackView()
		registerStackiew.translatesAutoresizingMaskIntoConstraints = false
		registerStackiew.axis = .horizontal
		registerStackiew.distribution = .fillEqually
		registerStackiew.spacing = 20
		return registerStackiew
	}()
	private let registerLabel: UILabel = {
		let registerLabel = UILabel()
		registerLabel.translatesAutoresizingMaskIntoConstraints = false
		registerLabel.text = "Haven't account yet?"
		registerLabel.textColor = .white
		registerLabel.textAlignment = .center
		registerLabel.font = UIFont(name: "ChalkboardSE-Light" , size: 15)
		return registerLabel
	}()
	private let registerButton: UIButton = {
		let registerButton = UIButton()
		registerButton.translatesAutoresizingMaskIntoConstraints = false
		registerButton.setTitle("Register!", for: .normal)
		registerButton.setTitleColor(.white, for: .normal)
		registerButton.backgroundColor = UIColor(red: 0.16, green: 0.27, blue: 0.99, alpha: 1.00).withAlphaComponent(0.4)
		registerButton.layer.cornerRadius = 10
		registerButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Light", size: 15)
		return registerButton
	}()
	private let loginField: UITextField = {
		let loginField = UITextField()
		loginField.translatesAutoresizingMaskIntoConstraints = false
		loginField.backgroundColor = UIColor(red: 0.16, green: 0.27, blue: 0.99, alpha: 1.00).withAlphaComponent(0.4)
		loginField.attributedPlaceholder = NSAttributedString(
			string: "login",
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.2)])
		loginField.font = UIFont(name: "ChalkboardSE-Light" , size: 20)
		loginField.textColor = .white
		loginField.layer.masksToBounds = true
		loginField.returnKeyType = .next
		loginField.layer.cornerRadius = 6
		return loginField
	}()
	private let passwordField: UITextField = {
		let passwordField = UITextField()
		passwordField.translatesAutoresizingMaskIntoConstraints = false
		passwordField.backgroundColor = UIColor(red: 0.16, green: 0.27, blue: 0.99, alpha: 1.00).withAlphaComponent(0.4)
		passwordField.attributedPlaceholder = NSAttributedString(
			string: "password",
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.2)])
		passwordField.textContentType = .password
		passwordField.font = UIFont(name: "ChalkboardSE-Light" , size: 20)
		passwordField.textColor = .white
		passwordField.layer.masksToBounds = true
		passwordField.layer.cornerRadius = 6
		passwordField.isSecureTextEntry = true
		passwordField.returnKeyType = .done
		return passwordField
	}()
	private let enterButton: UIButton = {
		let enterButton = UIButton()
		enterButton.translatesAutoresizingMaskIntoConstraints = false
		enterButton.backgroundColor = UIColor(red: 0.16, green: 0.27, blue: 0.99, alpha: 1.00)
		enterButton.setTitle("Enter", for: .normal)
		enterButton.layer.cornerRadius = 10
		enterButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Light", size: 20)
		return enterButton
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		createBackground()
		addSubviews()
		setUpConstraints()
		setUpRecognizer()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		passwordField.text = nil
		loginField.text = nil
	}

	private func createBackground(){
		fonImage.image = UIImage(named: "fon")
		fonImage.contentMode = UIView.ContentMode.scaleAspectFill
		fonImage.alpha = 0.8
		self.view.insertSubview(fonImage, at: 0)
	}

	private func addSubviews(){
		view.addSubview(hiLabel)
		view.addSubview(loginField)
		view.addSubview(passwordField)
		view.addSubview(enterButton)
		registerStackiew.addArrangedSubview(registerLabel)
		registerStackiew.addArrangedSubview(registerButton)
		view.addSubview(registerStackiew)
		view.addSubview(seepasswordButton)
	}
	
	private func setUpRecognizer(){
		let enterRecognizer = UITapGestureRecognizer(target: self, action: #selector(enterButtonAction))
		enterButton.addGestureRecognizer(enterRecognizer)
		let registerRecognizer = UITapGestureRecognizer(target: self, action: #selector(registerButtonAction))
		registerButton.addGestureRecognizer(registerRecognizer)
		let passwordRecognizer = UITapGestureRecognizer(target: self, action: #selector(seePassword))
		seepasswordButton.addGestureRecognizer(passwordRecognizer)
	}

	@objc private func enterButtonAction() {
		guard let username = loginField.text,
			  let password = passwordField.text else { return }
		authorizated(login: username, password: password)
	}

	private func authorizated(login: String, password: String) {
		let authorizationResult = accountManager.authorization(username: login, password: password)
		switch authorizationResult {
		case .success():
			presentPhotoManager()
		case .failure(let error):
			presentAlert(error: error)
		}
	}

	private func presentPhotoManager() {
		let photoManagerVC = PhotoManagerViewController()
		let managerNavigationController = UINavigationController(rootViewController: photoManagerVC)
		managerNavigationController.modalPresentationStyle = .fullScreen
		navigationController?.present(managerNavigationController, animated: true)
	}

	@objc private func registerButtonAction() {
		let registerVC = RegisterViewController()
		registerVC.delegate = self
		navigationController?.present(registerVC, animated: true)
	}

	@objc private func seePassword() {
		passwordField.isSecureTextEntry.toggle()
		let passwordImage = passwordField.isSecureTextEntry ?
		UIImage(named: "eye")?.withTintColor(.white) : UIImage(named: "password")?.withTintColor(.white)
		seepasswordButton.setImage(passwordImage, for: .normal)
	}

	private func presentAlert(error: PossibleErrors) {
		let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .cancel)
		alert.addAction(action)
		self.present(alert, animated: true)
	}

	private func setUpConstraints(){
		NSLayoutConstraint.activate(
			[
				hiLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 6),
				hiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
				hiLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

				loginField.topAnchor.constraint(equalTo: hiLabel.bottomAnchor, constant: 20),
				loginField.leadingAnchor.constraint(equalTo: hiLabel.leadingAnchor),
				loginField.trailingAnchor.constraint(equalTo: hiLabel.trailingAnchor),

				passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 20),
				passwordField.leadingAnchor.constraint(equalTo: hiLabel.leadingAnchor),
				passwordField.trailingAnchor.constraint(equalTo: hiLabel.trailingAnchor),

				enterButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
				enterButton.leadingAnchor.constraint(equalTo: hiLabel.leadingAnchor),
				enterButton.trailingAnchor.constraint(equalTo: hiLabel.trailingAnchor),

				registerStackiew.topAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 10),
				registerStackiew.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
				registerStackiew.trailingAnchor.constraint(equalTo: hiLabel.trailingAnchor),

				seepasswordButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: -5),
				seepasswordButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
				seepasswordButton.widthAnchor.constraint(equalToConstant: 20),
				seepasswordButton.heightAnchor.constraint(equalToConstant: 20)
			]
		)
	}
}



extension StartViewController: StartViewControllerProtocol {
	func newAccountWasRegister(username: String, password: String) {
		authorizated(login: username, password: password)
	}
}
