
extension CharacterDTO {

    func toDomain() -> Character {

        Character(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            originName: origin?.name,
            originURL: origin?.url,
            locationName: location?.name,
            locationURL: location?.url,
            image: image,
            episode: episode,
            url: url,
            created: created
        )
    }
}
