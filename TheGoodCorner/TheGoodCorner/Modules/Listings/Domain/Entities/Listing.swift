//
//  Listing.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 11/8/2026.
//

import Foundation

struct Listing: Identifiable, Equatable {

    let id: Int?
    let title: String?
    let description: String?
    let price: Int?
    let categoryId: Int?
    let isUrgent: Bool?
    let creationDate: String?
    let thumbnailURL: URL?
    let imageURL: URL?
}
