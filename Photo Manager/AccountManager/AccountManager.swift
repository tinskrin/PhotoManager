//
//  AccountManager.swift
//  Photo Manager
//
//  Created by Kris on 11.10.2022.
//

import Foundation

final class AccountManager {

	static let shared = AccountManager()

	private var accounts: [String: String] = [:]

	private init() {
		if let accounts = UserDefaults.standard.value(forKey: "accounts") as? [String: String] {
			self.accounts = accounts
		}
	}

	func createAccount(username: String, password: String) -> Result<Void, PossibleErrors> {
		if username.isEmpty || password.isEmpty {
			return .failure(.emptyField)
		} else if let _ = accounts[username] {
			return .failure(.userExist)
		} else if password.count < 8 {
			return .failure(.shortPassword)
		} else {
			accounts.updateValue(password, forKey: username)
			UserDefaults.standard.set(accounts, forKey: "accounts")
		}
		return .success(Void())
	}

	func authorization(username: String, password: String) -> Result<Void, PossibleErrors> {
		if let userPassword = accounts[username],
		   userPassword == password {
			return .success(Void())
		} else if let userPassword = accounts[username],
				  userPassword != password {
			return .failure(.wrongPassword)
		} else if username.isEmpty || password.isEmpty {
			return .failure(.emptyField)
		} else if !accounts.keys.contains(username) {
			return .failure(.userDoesntExist)
		}
		return .failure(.unknown)
	}
}
