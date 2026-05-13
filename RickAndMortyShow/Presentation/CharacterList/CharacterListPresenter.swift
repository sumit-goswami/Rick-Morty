
import Foundation

@MainActor
final class CharacterListPresenter {

    private let useCase:
    FetchCharactersUseCase

    private let favoritesStore =
    FavoritesStore()

    private(set) var characters:
    [Character] = []

    var onReload: (() -> Void)?

    var selectedStatus: String?

    private var nextPageURL: String?
    
    private var isLoadingNextPage = false

    private var lastRequestedURL: String?

    private var hasReachedEnd = false
    
    private var currentSearchQuery = ""

    init(useCase: FetchCharactersUseCase) {

        self.useCase = useCase

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadCache),
            name: .didUpdateCharacters,
            object: nil
        )
    }

    func loadInitialData() async {

        characters =
            useCase.loadCachedCharacters()

        onReload?()

        await useCase.refreshCharacters(
            urlString: nil,
            query: nil,
            status: selectedStatus
        )

        nextPageURL =
            useCase.nextPageURL
    }

    func loadNextPage() async {

        // MARK: - Prevent Multiple Calls

        guard !isLoadingNextPage else {
            return
        }

        // MARK: - No More Pages

        guard !hasReachedEnd else {
            return
        }


        // MARK: - Duplicate Request Protection

        guard lastRequestedURL != nextPageURL else {
            return
        }

        isLoadingNextPage = true

        lastRequestedURL = nextPageURL

        defer {

            isLoadingNextPage = false
        }

        await useCase.refreshCharacters(
            urlString: nextPageURL,
            query: nil,
            status: selectedStatus
        )

        self.nextPageURL =
            useCase.nextPageURL

        // MARK: - End Detection

        if self.nextPageURL == nil {

            hasReachedEnd = true
        }
    }

    func search(query: String) async {

        currentSearchQuery = query

        resetPaginationState()

        await useCase.refreshCharacters(
            urlString: nil,
            query: query,
            status: selectedStatus
        )

        nextPageURL =
            useCase.nextPageURL
    }

    func toggleFavorite(id: Int) {
        favoritesStore.toggle(id: id)
    }

    func isFavorite(id: Int) -> Bool {
        favoritesStore.isFavorite(id: id)
    }

    @objc
    private func reloadCache() {

        characters =
            useCase.loadCachedCharacters()

        onReload?()
    }
    
    func applyFilter() async {

        resetPaginationState()

        await useCase.refreshCharacters(
            urlString: nil,
            query: currentSearchQuery,
            status: selectedStatus
        )

        nextPageURL =
            useCase.nextPageURL
    }
    
    private func resetPaginationState() {

        nextPageURL = nil

        lastRequestedURL = nil

        hasReachedEnd = false

        isLoadingNextPage = false
    }
}
