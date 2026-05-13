
final class FetchCharactersUseCase {

    private let repository:
        CharacterRepository

    init(repository: CharacterRepository) {
        self.repository = repository
    }

    // MARK: - Cache

    func loadCachedCharacters() -> [Character] {

        repository.getCachedCharacters()
    }

    // MARK: - Refresh

    func refreshCharacters(
        urlString: String?,
        query: String?,
        status: String?
    ) async {

        await repository.refreshCharacters(
            urlString: urlString,
            query: query,
            status: status
        )
    }

    // MARK: - Pagination

    var nextPageURL: String? {

        (repository as? CharacterRepositoryImpl)?
            .nextPageURL
    }
}
