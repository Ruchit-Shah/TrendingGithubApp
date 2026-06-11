//
//  RepositoryRowView.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import SwiftUI

struct RepositoryRowView: View {

    let repository: Repository

    var body: some View {

        HStack {

            AsyncImage(
                url: URL(
                    string:
                    repository.owner.avatarURL
                )
            )

            { image in

                image
                    .resizable()

            } placeholder: {

                ProgressView()
            }

            .frame(
                width: 50,
                height: 50
            )

            VStack(
                alignment: .leading
            ) {

                Text(repository.name)

                Text(
                    repository.language
                    ?? "Unknown"
                )

                Text(
                    "⭐️ \(repository.stargazersCount)"
                )
            }
        }
    }
}
