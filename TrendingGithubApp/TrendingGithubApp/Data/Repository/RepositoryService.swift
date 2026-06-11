//
//  RepositoryService.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation
import Combine

final class RepositoryService:
RepositoryServiceProtocol {

    private let apiClient: APIClient
    private let cacheService: CacheServiceProtocol

    init(
        apiClient: APIClient,
        cacheService: CacheServiceProtocol
    ) {

        self.apiClient = apiClient
        self.cacheService = cacheService
    }

    func fetchRepositories(
        page: Int
    ) -> AnyPublisher<[Repository], Error> {

        apiClient
            .fetchRepositories(page: page)

            .handleEvents(
                receiveOutput: { [weak self]
                    repos in

                    self?.cacheService
                        .save(repositories: repos)
                }
            )

            .catch { [weak self] error in

                let cached =
                self?.cacheService
                    .fetchRepositories() ?? []

                if cached.isEmpty {

                    return Fail<[Repository], Error>(
                        error: error
                    )
                    .eraseToAnyPublisher()
                }

                return Just(cached)
                    .setFailureType(
                        to: Error.self
                    )
                    .eraseToAnyPublisher()
            }

            .eraseToAnyPublisher()
    }
}
