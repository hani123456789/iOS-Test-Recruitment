//
//  CategoriesRepositoryProtocol.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 12/8/2026.
//

import Foundation

@MainActor
protocol CategoriesRepositoryProtocol {
    func fetchCategories() async throws -> [Category]
}
