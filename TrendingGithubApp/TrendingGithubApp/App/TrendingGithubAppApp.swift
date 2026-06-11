//
//  TrendingGithubAppApp.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import SwiftUI

@main
struct TrendingGithubApp: App {

    private let container = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            RepositoryListView(
                viewModel: container.makeRepositoryListViewModel()
            )
        }
    }
}
