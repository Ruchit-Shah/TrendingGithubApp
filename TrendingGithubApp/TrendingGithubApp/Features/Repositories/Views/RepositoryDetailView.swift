//
//  RepositoryDetailView.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import SwiftUI

struct RepositoryDetailView: View {

    let repository: Repository

    var body: some View {

        ScrollView {

            VStack(
                spacing: 16
            ) {

                Text(repository.name)

                Text(
                    repository.description
                    ?? "No Description"
                )

                Text(
                    "⭐️ \(repository.stargazersCount)"
                )

                Text(
                    repository.language
                    ?? "Unknown"
                )
            }
        }
    }
}
