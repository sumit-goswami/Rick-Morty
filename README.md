# Rick And Morty Show iOS App

A modern UIKit-based iOS application built using Clean Architecture principles with offline-first support, infinite scrolling, image caching, search, filters, favorites, shimmer loading, and Core Data persistence.

The app consumes the public Rick & Morty API:

[https://rickandmortyapi.com/documentation](https://rickandmortyapi.com/documentation)

---

# Features

## Character Listing

* Infinite scrolling pagination
* API-driven pagination using `info.next`
* Pull-to-refresh support
* Smooth UITableView performance

## Search

* Debounced search using Swift Concurrency (`Task`)
* Live search updates
* Search combined with filters

## Filters

* Alive
* Dead
* Unknown
* Combined with search

## Character Details

* Dedicated details screen
* Full character metadata
* Large avatar image
* Scrollable layout

## Favorites

* Toggle favorite state
* Persisted locally
* Heart icon interaction

## Offline Support

* Core Data persistence
* Offline-first loading flow
* Cached character list shown immediately on app launch

## Image Loading

* Custom image loader
* Memory caching
* URLSession caching
* Request cancellation
* Smooth cell reuse handling

## Dark Mode Support

* Semantic system colors
* Fully adaptive UI

## Architecture

* Clean Architecture
* Repository Pattern
* Dependency Injection
* Coordinator-based navigation
* UIKit + Programmatic UI

---

# App Flow

```text
Open App
↓
Load Cached Data From Core Data
↓
Show Cached UI Immediately
↓
Call API
↓
API Success
↓
Update Core Data
↓
Refresh UI
```

---

# Tech Stack

| Technology          | Usage                |
| ------------------- | -------------------- |
| UIKit               | UI Framework         |
| Core Data           | Offline persistence  |
| URLSession          | Networking           |
| Swift Concurrency   | Async/Await          |
| NSCache             | Image memory caching |
| Clean Architecture  | Project structure    |
| UITableView         | Navigation           |
|                     | Character listing    |

---

# Project Structure

```text
RickAndMortyShow
│
├── Application
│   ├── AppDelegate
│   ├── SceneDelegate
│   └── AppDIContainer
│
├── Data
│   ├── Network
│   ├── Repository
│   ├── Persistence
│   └── DTOs
│
├── Domain
│   ├── Entities
│   ├── RepositoryInterfaces
│   └── UseCases
│
├── Presentation
│   ├── CharacterList
│   ├── CharacterDetail
│   ├── Shared
│   └── Coordinator
│
└── Resources
    └── CoreDataModel
```

---

# API Pagination Strategy

The app uses backend-driven pagination instead of manually incrementing pages.

Example API response:

```json
{
  "info": {
    "next": "https://rickandmortyapi.com/api/character?page=2"
  }
}
```

The app stores and uses:

* `nextPageURL`
* `prevPageURL`

This makes pagination:

* safer
* scalable
* backend-controlled

---

# Image Loading Strategy

The app includes a reusable image loading system with:

* request cancellation
* memory caching
* URL cache support
* placeholder handling
* cell reuse protection

Images are cached using:

* character ID as cache key

---

# Search Debounce

Implemented using Swift Concurrency:

```swift
Task.sleep(for: .milliseconds(500))
```

This prevents:

* API spam
* unnecessary reloads
* poor typing UX

---

# Core Data

The app stores:

* character metadata
* origin
* location
* episode list
* favorites

Used for:

* offline mode
* instant app launch
* cached browsing experience

---

# Infinite Scroll Protection

Pagination includes:

* duplicate request prevention
* loading state handling
* end-of-list detection
* next page deduplication

---

# Requirements

* Xcode 16+
* iOS 16+
* Swift 5.9+

---

# How To Run

1. Clone/download the project
2. Open `.xcodeproj`
3. Clean build folder:

   * `Shift + Command + K`
4. Run on simulator/device

---


# Screens Included

* Character List
* Search + Filters
* Favorites
* Character Details
* Skeleton Loading
* Offline Cached State

---

* Clean Architecture
* UIKit
* Core Data
* Async/Await
* Coordinator Pattern
