
import Foundation
import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {

        let container =
            NSPersistentContainer(name: "RickAndMortyShow")

        container.loadPersistentStores { _, error in

            if let error {
                fatalError(error.localizedDescription)
            }
        }

        return container
    }()

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {

        guard context.hasChanges else { return }

        try? context.save()
    }
}
