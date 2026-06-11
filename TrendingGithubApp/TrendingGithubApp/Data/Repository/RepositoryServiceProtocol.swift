//
//  RepositoryServiceProtocol.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation
import Combine

protocol RepositoryServiceProtocol {

    func fetchRepositories(
        page: Int
    ) -> AnyPublisher<[Repository], Error>
}
