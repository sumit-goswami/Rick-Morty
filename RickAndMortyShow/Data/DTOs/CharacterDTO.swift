

struct CharactersResponseDTO: Decodable {

    let info: PageInfoDTO
    let results: [CharacterDTO]
}

struct PageInfoDTO: Decodable {

    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct CharacterDTO: Decodable {

    let id: Int
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin: OriginDTO?
    let location: LocationDTO?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

// MARK: - Origin

struct OriginDTO: Decodable {

    let name: String?
    let url: String?
}

// MARK: - Location

struct LocationDTO: Decodable {

    let name: String?
    let url: String?
}
