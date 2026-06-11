//
//  Endpoint.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation

enum Endpoint {

    static func repositories(page: Int) -> URL? {

        var components = URLComponents(
            string: "https://api.github.com/search/repositories"
        )

        components?.queryItems = [
            URLQueryItem(name: "q", value: "stars:>1000"),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        return components?.url
    }
}
