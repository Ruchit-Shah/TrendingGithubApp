//
//  CacheService.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import CoreData
import Foundation

protocol CacheServiceProtocol {

    func save(
        repositories: [Repository]
    )

    func fetchRepositories()
    -> [Repository]
}

final class CacheService: CacheServiceProtocol {

    private let coreDataManager: CoreDataManager

    init(
        coreDataManager: CoreDataManager = .shared
    ) {

        self.coreDataManager = coreDataManager
    }

    func save(
        repositories: [Repository]
    ) {

        let context =
        coreDataManager.container.viewContext

        context.performAndWait {

            do {

                let fetchRequest =
                NSFetchRequest<NSManagedObject>(
                    entityName: "Entity"
                )

                let existingRepositories =
                try context.fetch(fetchRequest)

                existingRepositories.forEach {
                    context.delete($0)
                }

                repositories.forEach {
                    repository in

                    let cachedRepository =
                    NSEntityDescription.insertNewObject(
                        forEntityName: "Entity",
                        into: context
                    )

                    cachedRepository.setValue(
                        Int64(repository.id),
                        forKey: "id"
                    )
                    cachedRepository.setValue(
                        repository.name,
                        forKey: "name"
                    )
                    cachedRepository.setValue(
                        repository.description,
                        forKey: "descriptionText"
                    )
                    cachedRepository.setValue(
                        Int64(repository.stargazersCount),
                        forKey: "stars"
                    )
                    cachedRepository.setValue(
                        repository.language,
                        forKey: "language"
                    )
                    cachedRepository.setValue(
                        repository.owner.login,
                        forKey: "ownerName"
                    )
                    cachedRepository.setValue(
                        repository.owner.avatarURL,
                        forKey: "avatarURL"
                    )
                }

                if context.hasChanges {

                    try context.save()
                }
            } catch {

                context.rollback()
            }
        }
    }

    func fetchRepositories()
    -> [Repository] {

        let context =
        coreDataManager.container.viewContext

        var repositories: [Repository] = []

        context.performAndWait {

            do {

                let fetchRequest =
                NSFetchRequest<NSManagedObject>(
                    entityName: "Entity"
                )

                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(
                        key: "stars",
                        ascending: false
                    )
                ]

                repositories =
                try context.fetch(fetchRequest)
                    .map {
                        cachedRepository in

                        Repository(
                            id: Int(
                                cachedRepository.value(
                                    forKey: "id"
                                ) as? Int64 ?? 0
                            ),
                            name: cachedRepository.value(
                                forKey: "name"
                            ) as? String ?? "",
                            description: cachedRepository.value(
                                forKey: "descriptionText"
                            ) as? String,
                            stargazersCount: Int(
                                cachedRepository.value(
                                    forKey: "stars"
                                ) as? Int64 ?? 0
                            ),
                            language: cachedRepository.value(
                                forKey: "language"
                            ) as? String,
                            owner: Owner(
                                login: cachedRepository.value(
                                    forKey: "ownerName"
                                ) as? String ?? "",
                                avatarURL: cachedRepository.value(
                                    forKey: "avatarURL"
                                ) as? String ?? ""
                            )
                        )
                    }
            } catch {

                repositories = []
            }
        }

        return repositories
    }
}
