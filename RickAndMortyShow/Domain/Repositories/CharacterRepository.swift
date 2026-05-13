
protocol CharacterRepository {

    var nextPageURL: String? { get }

    func getCachedCharacters() -> [Character]

    func refreshCharacters(
        urlString: String?,
        query: String?,
        status: String?
    ) async
}
