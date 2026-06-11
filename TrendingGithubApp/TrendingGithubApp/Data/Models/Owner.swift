//
//  Owner.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation

struct Owner: Codable {

    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {

        case login

        case avatarURL =
        "avatar_url"
    }
}
