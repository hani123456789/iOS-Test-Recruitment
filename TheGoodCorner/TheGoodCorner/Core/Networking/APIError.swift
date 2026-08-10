//
//  APIError.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 10/8/2026.
//

import Foundation

enum APIError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
    case networkError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."

        case .invalidResponse:
            return "The server returned an invalid response."

        case .httpError(let statusCode):
            return "The server returned an error (HTTP \(statusCode))."

        case .decodingError:
            return "We couldn't read the server response."

        case .networkError:
            return "Unable to connect to the server."

        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
