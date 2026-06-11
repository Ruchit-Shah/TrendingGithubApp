//
//  RepositoryListView.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import SwiftUI

struct RepositoryListView: View {

    @StateObject var viewModel:
    RepositoryListViewModel

    var body: some View {

        NavigationStack {

            List {

                ForEach(
                    viewModel.repositories
                ) { repo in

                    NavigationLink {

                        RepositoryDetailView(
                            repository: repo
                        )

                    } label: {

                        RepositoryRowView(
                            repository: repo
                        )
                    }
                }

                Button("Load More") {

                    viewModel.fetchRepositories()
                }
            }

            .searchable(
                text:
                $viewModel.searchText
            )

            .refreshable {

                viewModel.fetchRepositories()
            }

            .navigationTitle(
                "Trending Repositories"
            )
        }
    }
}
