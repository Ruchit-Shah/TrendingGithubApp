//
//  GitHubAPIClient.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation
import Combine

final class GitHubAPIClient: APIClient {

    func fetchRepositories(
        page: Int
    ) -> AnyPublisher<[Repository], Error> {

        guard let url =
                Endpoint.repositories(page: page)
        else {

            return Fail(
                error: NetworkError.invalidURL
            )
            .eraseToAnyPublisher()
        }

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(
                type: GitHubResponse.self,
                decoder: JSONDecoder()
            )
            .map(\.items)
            .eraseToAnyPublisher()
    }
}
