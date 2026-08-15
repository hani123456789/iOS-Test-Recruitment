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
            return AppStrings.Errors.invalidURL
        case .invalidResponse:
            return AppStrings.Errors.invalidResponse
        case .httpError(let statusCode):
            return AppStrings.Errors.httpError(statusCode)
        case .decodingError:
            return AppStrings.Errors.decodingError
        case .networkError:
            return AppStrings.Errors.networkError
        case .unknown:
            return AppStrings.Errors.unknown
        }
    }
}
