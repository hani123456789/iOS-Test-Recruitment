//
//  State.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 14/8/2026.
//

enum State: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(APIError)
}
