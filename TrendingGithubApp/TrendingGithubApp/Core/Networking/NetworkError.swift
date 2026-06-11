//
//  NetworkError.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation

enum NetworkError: LocalizedError {

    case invalidURL
    case invalidResponse
    case decodingError

    var errorDescription: String? {

        switch self {

        case .invalidURL:
            return "Invalid URL"

        case .invalidResponse:
            return "Invalid Response"

        case .decodingError:
            return "Decoding Error"
        }
    }
}
