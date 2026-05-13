
import Foundation

protocol NetworkServiceProtocol {

    func fetchCharacters(
        urlString: String?,
        query: String?,
        status: String?
    ) async throws -> CharactersResponseDTO
}

final class NetworkService: NetworkServiceProtocol {

    func fetchCharacters(
        urlString: String?,
        query: String?,
        status: String?
    ) async throws -> CharactersResponseDTO {

        let finalURL: URL

        // MARK: - First Page

        if let urlString,
           let url = URL(string: urlString) {

            finalURL = url

        } else {

            var components = URLComponents(
                string:
                "https://rickandmortyapi.com/api/character"
            )!

            var queryItems: [URLQueryItem] = []

            if let query,
               !query.isEmpty {

                queryItems.append(
                    URLQueryItem(
                        name: "name",
                        value: query
                    )
                )
            }

            if let status,
               !status.isEmpty {

                queryItems.append(
                    URLQueryItem(
                        name: "status",
                        value: status
                    )
                )
            }

            components.queryItems = queryItems

            finalURL = components.url!
        }
        print("SRG == \(finalURL.absoluteString)")
        let (data, _) =
            try await URLSession.shared.data(
                from: finalURL
            )

        return try JSONDecoder().decode(
            CharactersResponseDTO.self,
            from: data
        )
    }
}
