
import Foundation

final class FavoritesStore {

    private let key = "favorite_ids"

    func toggle(id: Int) {

        var ids = favoriteIDs()

        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }

        UserDefaults.standard.set(
            Array(ids),
            forKey: key
        )
    }

    func isFavorite(id: Int) -> Bool {
        favoriteIDs().contains(id)
    }

    private func favoriteIDs() -> Set<Int> {

        let ids =
            UserDefaults.standard.array(forKey: key)
            as? [Int] ?? []

        return Set(ids)
    }
}
