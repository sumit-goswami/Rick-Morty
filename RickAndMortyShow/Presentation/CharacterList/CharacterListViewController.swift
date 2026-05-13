
import UIKit

final class CharacterListViewController:
UIViewController {

    private let presenter:
    CharacterListPresenter

    private let tableView = UITableView()

    private let searchController =
        UISearchController()

    private let filterControl =
        UISegmentedControl(
            items: ["All","Alive","Dead","Unknown"]
        )

    private let skeletonView = UIView()
    
    private var searchTask:
    Task<Void, Never>?
    
    private let imageLoader =
        ImageLoader()

    init(presenter: CharacterListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Rick & Morty"

        view.backgroundColor =
            .systemBackground

        setupUI()

        bind()

        Task {
            await presenter.loadInitialData()
        }
    }

    private func setupUI() {

        navigationItem.searchController =
            searchController

        searchController.searchResultsUpdater =
            self

        navigationItem.titleView = filterControl

        filterControl.addTarget(
            self,
            action: #selector(filterChanged),
            for: .valueChanged
        )
        filterControl.selectedSegmentIndex = 0

        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self

        skeletonView.frame = view.bounds
        skeletonView.backgroundColor =
            .secondarySystemBackground
        
        tableView.register(
            CharacterCell.self,
            forCellReuseIdentifier:
                CharacterCell.reuseIdentifier
        )
        tableView.rowHeight = 90

        view.addSubview(tableView)
        view.addSubview(skeletonView)
    }

    private func bind() {

        presenter.onReload = { [weak self] in

            DispatchQueue.main.async {

                self?.skeletonView.isHidden = true

                self?.tableView.reloadData()
            }
        }
    }

    @objc
    private func filterChanged() {

        switch filterControl.selectedSegmentIndex {

        case 1:
            presenter.selectedStatus = "alive"

        case 2:
            presenter.selectedStatus = "dead"

        case 3:
            presenter.selectedStatus = "unknown"

        default:
            presenter.selectedStatus = nil
        }

        Task {

            await presenter.applyFilter()
        }
    }
    
}

extension CharacterListViewController:
UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        presenter.characters.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell =
            tableView.dequeueReusableCell(
                withIdentifier:
                    CharacterCell.reuseIdentifier,
                for: indexPath
            ) as? CharacterCell else {

            return UITableViewCell()
        }

        let character =
            presenter.characters[indexPath.row]

        cell.configure(
            with: character,
            isFavorite:
                presenter.isFavorite(
                    id: character.id
                ), imageLoader: imageLoader
        )
        
        cell.onFavoriteTap = {
            [weak self] in

            guard let self else {
                return
            }

            let character =
                self.presenter.characters[
                    indexPath.row
                ]

            self.presenter.toggleFavorite(
                id: character.id
            )

            tableView.reloadRows(
                at: [indexPath],
                with: .none
            )
        }

        return cell
    }
}

extension CharacterListViewController:
UITableViewDelegate {

    func scrollViewDidScroll(
        _ scrollView: UIScrollView
    ) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY >
            contentHeight - scrollView.frame.height * 3 {

            Task {
                await presenter.loadNextPage()
            }
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        let character =
            presenter.characters[indexPath.row]

        let vc =
            CharacterDetailViewController(
                character: character,
                imageLoader: imageLoader
            )

        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
}

extension CharacterListViewController:
UISearchResultsUpdating {

    func updateSearchResults(
        for searchController: UISearchController
    ) {

        let query =
            searchController.searchBar.text ?? ""

        // MARK: - Cancel Previous Search

        searchTask?.cancel()

        // MARK: - Debounce

        searchTask = Task {

            do {

                try await Task.sleep(
                    for: .milliseconds(500)
                )

            } catch {

                return
            }

            // MARK: - Ignore Cancelled Tasks

            guard !Task.isCancelled else {
                return
            }

            await presenter.search(
                query: query
            )
        }
    }
}
