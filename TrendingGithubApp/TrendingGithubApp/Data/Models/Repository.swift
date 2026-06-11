//
//  Repository.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation

struct Repository: Codable, Identifiable {

    let id: Int
    let name: String
    let description: String?
    let stargazersCount: Int
    let language: String?
    let owner: Owner

    enum CodingKeys: String, CodingKey {

        case id
        case name
        case description
        case language
        case owner

        case stargazersCount =
        "stargazers_count"
    }
}
