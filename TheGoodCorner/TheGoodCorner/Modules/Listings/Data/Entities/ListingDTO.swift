//
//  ListingDTO.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 11/8/2026.
//

import Foundation

struct ListingDTO: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let price: Int?
    let categoryId: Int?
    let isUrgent: Bool?
    let creationDate: String?
    let imagesURL: ImagesURLDTO?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case categoryId = "category_id"
        case isUrgent = "is_urgent"
        case creationDate = "creation_date"
        case imagesURL = "images_url"
    }
}

// MARK: - Mapping

extension ListingDTO {

    func toDomain(baseURL: URL) -> Listing {
        Listing(
            id: id,
            title: title,
            description: description,
            price: price,
            categoryId: categoryId,
            isUrgent: isUrgent,
            creationDate: creationDate,
            thumbnailURL: makeURL(
                imagesURL?.thumb,
                baseURL: baseURL
            ),
            imageURL: makeURL(
                imagesURL?.small,
                baseURL: baseURL
            )
        )
    }

    private func makeURL(
        _ path: String?,
        baseURL: URL
    ) -> URL? {
        guard let path else {
            return nil
        }

        return URL(
            string: path,
            relativeTo: baseURL
        )
    }
}
