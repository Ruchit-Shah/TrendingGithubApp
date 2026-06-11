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

        guard let url = Endpoint.repositories(page: page) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { result in

                guard let response = result.response as? HTTPURLResponse,
                      200...299 ~= response.statusCode else {
                    throw NetworkError.invalidResponse
                }

                return result.data
            }
            .decode(
                type: GitHubResponse.self,
                decoder: JSONDecoder()
            )
            .map(\.items)
            .eraseToAnyPublisher()
    }
}
