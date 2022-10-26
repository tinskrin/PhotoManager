//
//  RegisterViewController.swift
//  Photo Manager
//
//  Created by Kris on 28.09.2022.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {

	weak var delegate: StartViewControllerProtocol?

	private let fonImage = UIImageView(frame: UIScreen.main.bounds)

	private let registerLabel: UILabel = {
		let registerLabel = UILabel()
		registerLabel.translatesAutoresizingMaskIntoConstraints = false
		registerLabel.text = "Register"
		registerLabel.textColor = .white
		registerLabel.textAlignment = .center
		registerLabel.font = UIFont(name: "ChalkboardSE-Regular" , size: 25)
		return registerLabel
	}()
	private let emailLabel: UILabel = {
		let emailLabel = UILabel()
		emailLabel.translatesAutoresizingMaskIntoConstraints = false
		emailLabel.text = "Email"
		emailLabel.textColor = .white
		emailLabel.font = UIFont(name: "ChalkboardSE-Regular" , size: 15)
		return emailLabel
	}()
	private let passwordLabel: UILabel = {
		let passwordLabel = UILabel()
		passwordLabel.translatesAutoresizingMaskIntoConstraints = false
		passwordLabel.text = "Password"
		passwordLabel.textColor = .white
		passwordLabel.font = UIFont(name: "ChalkboardSE-Regular" , size: 15)
		return passwordLabel
	}()
	private let emailField: UITextField = {
		let emailField = UITextField()
		emailField.translatesAutoresizingMaskIntoConstraints = false
		emailField.backgroundColor = UIColor(red: 0.16, green: 0.27, blue: 0.99, alpha: 1.00).withAlphaComponent(0.4)
		emailField.attributedPlaceholder = NSAttributedString(string: "login",
															  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.2)])
		emailField.font = UIFont(name: "ChalkboardSE-Light" , size: 20)
		emailField.returnKeyType = .next
		emailField.textColor = .white
		return emailField
	}()
	private let passwordField: UITextField = {
		let passwordField = UITextField()
		passwordField.translatesAutoresizingMaskIntoConstraints = false
		passwordField.backgroundColor = UIColor(red: 0.16, green: 0.27, blue: 0.99, alpha: 1.00).withAlphaComponent(0.4)
		passwordField.attributedPlaceholder = NSAttributedString(string: "password",
																 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.2)])
		passwordField.textContentType = .password
		passwordField.font = UIFont(name: "ChalkboardSE-Light" , size: 20)
		passwordField.textColor = .white
		passwordField.returnKeyType = .done
		passwordField.isSecureTextEntry = true
		return passwordField
	}()
	private let seepasswordButton: UIButton = {
		let seepasswordButton = UIButton()
		let passwordImage = UIImage(named: "eye")?.withTintColor(.white)
		seepasswordButton.setImage(passwordImage, for: .normal)
		seepasswordButton.translatesAutoresizingMaskIntoConstraints = false
		return seepasswordButton
	}()
	private let createAcccountButton: UIButton = {
		let createAcccountButton = UIButton()
		createAcccountButton.translatesAutoresizingMaskIntoConstraints = false
		createAcccountButton.backgroundColor = UIColor(red: 0.16, green: 0.27, blue: 0.99, alpha: 1.00)
		createAcccountButton.setTitle("Create account", for: .normal)
		createAcccountButton.layer.cornerRadius = 10
		createAcccountButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Light", size: 20)
		return createAcccountButton
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		createBackground()
		setUpRecognizer()
		setupViews()
		setUpConstraints()
	}

	private func createBackground(){
		fonImage.image = UIImage(named: "fon")
		fonImage.contentMode = UIView.ContentMode.scaleAspectFill
		fonImage.alpha = 0.8
		view.backgroundColor = .black
		self.view.insertSubview(fonImage, at: 1)
	}

	private func setupViews(){
		view.addSubview(registerLabel)
		view.addSubview(emailField)
		view.addSubview(emailLabel)
		view.addSubview(passwordField)
		view.addSubview(seepasswordButton)
		view.addSubview(passwordLabel)
		view.addSubview(createAcccountButton)
	}

	private func setUpRecognizer(){
		let createAcccountRecognizer = UITapGestureRecognizer(target: self, action: #selector(createAccountAction))
		createAcccountButton.addGestureRecognizer(createAcccountRecognizer)
		let passwordRecognizer = UITapGestureRecognizer(target: self, action: #selector(seePassword))
		seepasswordButton.addGestureRecognizer(passwordRecognizer)
	}

	@objc private func createAccountAction() {
		guard let username = emailField.text,
			  let password = passwordField.text else { return }
		let createAccountResult = AccountManager.shared.createAccount(username: username, password: password)
		switch createAccountResult {
		case .success():
			self.dismiss(animated: true)
			delegate?.newAccountWasRegister(username: username, password: password)
		case .failure(let error):
			presentAlert(error: error)
		}
	}

	private func presentAlert(error: PossibleErrors) {
		let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .cancel)
		alert.addAction(action)
		self.present(alert, animated: true)
	}

	@objc private func seePassword(){
		passwordField.isSecureTextEntry.toggle()
		let passwordImage = passwordField.isSecureTextEntry ?
		UIImage(named: "eye")?.withTintColor(.white) :
		UIImage(named: "password")?.withTintColor(.white)
		seepasswordButton.setImage(passwordImage, for: .normal)
	}

	private func setUpConstraints(){
		NSLayoutConstraint.activate(
			[
				registerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 6),
				registerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
				registerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

				emailField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40),
				emailField.leadingAnchor.constraint(equalTo: registerLabel.leadingAnchor),
				emailField.trailingAnchor.constraint(equalTo: registerLabel.trailingAnchor),

				emailLabel.bottomAnchor.constraint(equalTo: emailField.topAnchor, constant: -5),
				emailLabel.leadingAnchor.constraint(equalTo: registerLabel.leadingAnchor),
				emailLabel.trailingAnchor.constraint(equalTo: registerLabel.trailingAnchor),
				
				passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 40),
				passwordField.leadingAnchor.constraint(equalTo: registerLabel.leadingAnchor),
				passwordField.trailingAnchor.constraint(equalTo: registerLabel.trailingAnchor),

				passwordLabel.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -5),
				passwordLabel.leadingAnchor.constraint(equalTo: registerLabel.leadingAnchor),
				passwordLabel.trailingAnchor.constraint(equalTo: registerLabel.trailingAnchor),

				seepasswordButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: -5),
				seepasswordButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
				seepasswordButton.widthAnchor.constraint(equalToConstant: 20),
				seepasswordButton.heightAnchor.constraint(equalToConstant: 20),

				createAcccountButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
				createAcccountButton.leadingAnchor.constraint(equalTo: registerLabel.leadingAnchor),
				createAcccountButton.trailingAnchor.constraint(equalTo: registerLabel.trailingAnchor),
			]
		)
	}
}
