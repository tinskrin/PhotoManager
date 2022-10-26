//
//  PossibleErrors.swift
//  Photo Manager
//
//  Created by Kris on 19.10.2022.
//

import Foundation

enum PossibleErrors: Error {
	case wrongPassword
	case userDoesntExist
	case userExist
	case shortPassword
	case emptyField
	case unknown

	var title: String {
		switch self {
		case .wrongPassword:
			return "Try again"
		case .userDoesntExist:
			return "😿"
		case .userExist:
			return "😿"
		case .shortPassword:
			return "Try again"
		case .emptyField:
			return "Try again"
		case .unknown:
			return "Something went wrong"
		}
	}

	var message: String {
		switch self {
		case .wrongPassword:
			return "You enter wrong login or password"
		case .userDoesntExist:
			return "Sorry, this user doesn't exist"
		case .userExist:
			return "Sorry, user with this login already exist"
		case .shortPassword:
			return "Password main contest at list 8 symbols"
		case .emptyField:
			return "Sorry, it seems like you don't write username or login"
		case .unknown:
			return "Please, try again"
		}
	}
}
