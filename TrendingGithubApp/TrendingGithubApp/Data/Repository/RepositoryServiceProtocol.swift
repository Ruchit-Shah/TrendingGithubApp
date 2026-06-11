//
//  RepositoryServiceProtocol.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation
import Combine

protocol RepositoryServiceProtocol {

    var didReturnCachedData: Bool { get }

    func fetchRepositories(
        page: Int
    ) -> AnyPublisher<[Repository], Error>
}
