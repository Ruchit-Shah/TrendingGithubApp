# TrendingGithubApp

TrendingGithubApp is a SwiftUI application that displays trending GitHub repositories with search, pagination, pull-to-refresh, offline caching, and error handling.

This project is built as part of an iOS coding assignment focused on Combine, MVVM architecture, repository pattern, caching, and unit testing.

---

## Features

- Trending GitHub repositories list
- Repository detail screen
- Search repositories
- Search debounce using Combine
- Pull to refresh
- Load more pagination
- Offline cache using Core Data
- Error banner while keeping cached content visible
- Unit test for search debounce behavior
- Unit test for cache fallback on network failure

---

## Tech Stack

- Swift
- SwiftUI
- Combine
- MVVM
- Repository Pattern
- Core Data
- XCTest

---

## Architecture

The project follows **MVVM architecture** with a **Repository pattern**.

### Main Layers

```text
TrendingGithubApp
│
├── App
│   ├── TrendingGithubAppApp.swift
│   └── AppDIContainer.swift
│
├── Core
│   ├── Network
│   │   ├── APIClient.swift
│   │   ├── GitHubAPIClient.swift
│   │   ├── Endpoint.swift
│   │   └── NetworkError.swift
│   │
│   └── Cache
│       ├── CacheService.swift
│       └── CoreDataManager.swift
│
├── Data
│   ├── Models
│   │   ├── Repository.swift
│   │   ├── Owner.swift
│   │   └── GitHubResponse.swift
│   │
│   └── Repository
│       ├── RepositoryServiceProtocol.swift
│       └── RepositoryService.swift
│
├── Features
│   └── Repositories
│       ├── ViewModels
│       │   └── RepositoryListViewModel.swift
│       │
│       ├── Views
│       │   ├── RepositoryListView.swift
│       │   ├── RepositoryRowView.swift
│       │   └── RepositoryDetailView.swift
│       │
│       └── Components
│           ├── ErrorBannerView.swift
│           └── LoadingView.swift
│
└── TrendingGithubAppTests
    └── TrendingGithubAppTests.swift
