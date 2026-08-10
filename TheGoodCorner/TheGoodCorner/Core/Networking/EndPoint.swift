//
//  EndPoint.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 10/8/2026.
//

import Foundation

enum HTTPMethod: String {
    case GET
}

enum Endpoint {
    case listings(page: Int? = nil, limit: Int? = nil, query: String? = nil)
    case categories

    var method: HTTPMethod {
        .GET
    }

    func url(baseURL: URL) -> URL? {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )

        components?.queryItems = queryItems

        return components?.url
    }

    private var path: String {
        switch self {
        case .listings:
            return "listings"

        case .categories:
            return "categories"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case let .listings(page, limit, query):
            var items: [URLQueryItem] = []

            if let page {
                items.append(
                    URLQueryItem(
                        name: "page",
                        value: String(page)
                    )
                )
            }

            if let limit {
                items.append(
                    URLQueryItem(
                        name: "limit",
                        value: String(limit)
                    )
                )
            }

            if let query, !query.isEmpty {
                items.append(
                    URLQueryItem(
                        name: "query",
                        value: query
                    )
                )
            }

            return items.isEmpty ? nil : items
        case .categories:
            return nil
        }
    }
}
