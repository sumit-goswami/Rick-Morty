
import UIKit


final class AppDIContainer {

    func makeRootViewController() -> UIViewController {

        let networkService = NetworkService()

        let repository = CharacterRepositoryImpl(
            networkService: networkService
        )

        let useCase = FetchCharactersUseCase(
            repository: repository
        )

        let presenter = CharacterListPresenter(
            useCase: useCase
        )

        return CharacterListViewController(
            presenter: presenter
        )
    }
}
