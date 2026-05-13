import Foundation
import CoreData

final class CharacterRepositoryImpl:
CharacterRepository {

    private let networkService:
    NetworkServiceProtocol

    private let coreData =
        CoreDataStack.shared
    
    private(set) var nextPageURL: String?

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - Load Cached Data

    func getCachedCharacters() -> [Character] {

        let request:
        NSFetchRequest<CharacterEntity> =
            CharacterEntity.fetchRequest()

        let result = (
            try? coreData.context.fetch(request)
        ) ?? []

        return result.map {
            
            Character(id: Int($0.id),
                      name: $0.name ?? "",
                      status: $0.status ?? "",
                      species: $0.species ?? "",
                      type: $0.type ?? "",
                      gender: $0.gender ?? "",
                      originName: $0.originName ?? "",
                      originURL: $0.originURL ?? "",
                      locationName: $0.locationName ?? "",
                      locationURL: $0.locationURL ?? "",
                      image: $0.image ?? "",
                      episode: $0.episode as? [String] ?? [],
                      url: $0.url ?? "",
                      created: $0.created ?? ""
            )
        }
    }

    // MARK: - Refresh API

    func refreshCharacters(
        urlString: String?,
        query: String?,
        status: String?
    ) async {

        do {

            let response =
                try await networkService.fetchCharacters(
                    urlString: urlString,
                    query: query,
                    status: status
                )
            
            let isFirstPage =
            urlString == nil
            
            if isFirstPage {
                
                clearCharacters()
            }
            
            nextPageURL = response.info.next

            response.results.forEach { dto in
                
                guard !characterExists(
                    id: dto.id
                ) else {
                    return
                }
                
                let entity =
                CharacterEntity(
                    context: coreData.context
                )
                
                entity.id = Int64(dto.id)
                entity.name = dto.name
                entity.status = dto.status
                entity.species = dto.species
                entity.type = dto.type
                entity.gender = dto.gender
                entity.image = dto.image
                entity.url = dto.url
                entity.created = dto.created
                
                entity.episode =
                dto.episode as? NSObject
                
                entity.originName = dto.origin?.name
                entity.originURL = dto.origin?.url
                
                entity.locationName = dto.location?.name
                entity.locationURL = dto.location?.url
            }

            coreData.saveContext()

            NotificationCenter.default.post(
                name: .didUpdateCharacters,
                object: nil
            )

        } catch {

            print(error)
        }
    }
    
    private func characterExists(
        id: Int
    ) -> Bool {

        let request:
        NSFetchRequest<CharacterEntity> =
            CharacterEntity.fetchRequest()

        request.fetchLimit = 1

        request.predicate =
            NSPredicate(
                format: "id == %d",
                id
            )

        let count =
            (try? coreData.context.count(
                for: request
            )) ?? 0

        return count > 0
    }

    func searchCharacters(
        query: String,
        status: String?
    ) async {

        await refreshCharacters(
            urlString: nil,
            query: query,
            status: status
        )
    }

    // MARK: - Clear Cache

    private func clearCharacters() {

        let fetchRequest:
        NSFetchRequest<NSFetchRequestResult> =
            CharacterEntity.fetchRequest()

        let deleteRequest =
            NSBatchDeleteRequest(
                fetchRequest: fetchRequest
            )

        do {

            try coreData.context.execute(
                deleteRequest
            )

        } catch {

            print(error)
        }
    }
}

extension Notification.Name {

    static let didUpdateCharacters =
        Notification.Name("didUpdateCharacters")
}
