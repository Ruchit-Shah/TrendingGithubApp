//
//  CoreDataManager.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import CoreData

final class CoreDataManager {

    static let shared =
    CoreDataManager()

    let container:
    NSPersistentContainer

    init() {

        container =
        NSPersistentContainer(
            name: "RepoEntity"
        )

        container.loadPersistentStores {
            _, error in

            if let error {

                fatalError(
                    error.localizedDescription
                )
            }
        }
    }
}
