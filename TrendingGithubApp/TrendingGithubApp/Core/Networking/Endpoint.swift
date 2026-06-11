//
//  Endpoint.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation

enum Endpoint {

    static func repositories(
        page: Int
    ) -> URL? {

        URL(
            string:
            "https://api.github.com/search/repositories?q=stars:>1000&sort=stars&page=\(page)"
        )
    }
}
