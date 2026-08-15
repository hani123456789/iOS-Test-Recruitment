//
//  APIClient.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 10/8/2026.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T
}

final class APIClient: APIClientProtocol {

    private let session: URLSession
    private let baseURL: URL

    init(
        baseURL: URL,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    func request<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T {

        guard let url = endpoint.url(baseURL: baseURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.httpError(
                    statusCode: httpResponse.statusCode
                )
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingError
            }

        } catch let error as APIError {
            throw error

        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet,
                 .networkConnectionLost,
                 .cannotConnectToHost,
                 .timedOut:
                throw APIError.networkError

            default:
                throw APIError.unknown
            }

        } catch {
            throw APIError.unknown
        }
    }
}
