
import UIKit

final class CharacterDetailViewController:
UIViewController {

    private let character: Character

    // MARK: - UI

    private let scrollView = UIScrollView()

    private let contentStack = UIStackView()

    private let avatarImageView = UIImageView()
    
    private let imageLoader: ImageLoaderProtocol

    init(character: Character, imageLoader: ImageLoaderProtocol) {

        self.character = character
        self.imageLoader = imageLoader

        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = character.name

        view.backgroundColor =
            .systemBackground

        setupUI()

        configure()
    }

    // MARK: - Setup

    private func setupUI() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        contentStack.axis = .vertical
        contentStack.spacing = 16

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 16

        view.addSubview(scrollView)

        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            contentStack.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 20
            ),

            contentStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),

            contentStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),

            contentStack.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: -20
            )
        ])
    }

    // MARK: - Configure

    private func configure() {

        avatarImageView.heightAnchor.constraint(
            equalToConstant: 300
        ).isActive = true

        avatarImageView.setRemoteImage(
            id: character.id,
            urlString: character.image,
            imageLoader: imageLoader
        )

        contentStack.addArrangedSubview(
            avatarImageView
        )

        if let status = character.status, !status.isEmpty {
            addInfoView(
                title: "Status",
                value: status
            )
        }
        
        if let species = character.species, !species.isEmpty {
            addInfoView(
                title: "Species",
                value: species
            )
        }
        
        if let type = character.type, !type.isEmpty {
            addInfoView(
                title: "Type",
                value: type
            )
        }
        
        if let gender = character.gender, !gender.isEmpty {
            addInfoView(
                title: "Gender",
                value: gender
            )
        }
        
        if let origin = character.originName, !origin.isEmpty {
            addInfoView(
                title: "Origin",
                value: origin
            )
        }
        
        if let location = character.locationName, !location.isEmpty {
            addInfoView(
                title: "Location",
                value: location
            )
        }
        
        if let episode = character.episode, !episode.isEmpty {
            addInfoView(
                title: "Episodes",
                value: "\(episode.count)"
            )
        }
        
        if let created = character.created, !created.isEmpty {
            addInfoView(
                title: "Created",
                value: created.formattedDate()
            )
        }
    }

    // MARK: - Helper

    private func addInfoView(
        title: String,
        value: String
    ) {

        let container = UIView()

        container.backgroundColor =
            .secondarySystemBackground

        container.layer.cornerRadius = 12

        let titleLabel = UILabel()

        titleLabel.font =
            .preferredFont(
                forTextStyle: .headline
            )

        titleLabel.text = title

        let valueLabel = UILabel()

        valueLabel.font =
            .preferredFont(
                forTextStyle: .body
            )

        valueLabel.textColor =
            .secondaryLabel

        valueLabel.numberOfLines = 0

        valueLabel.text = value

        let stack = UIStackView(
            arrangedSubviews: [
                titleLabel,
                valueLabel
            ]
        )

        stack.axis = .vertical
        stack.spacing = 8

        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)

        NSLayoutConstraint.activate([

            stack.topAnchor.constraint(
                equalTo: container.topAnchor,
                constant: 16
            ),

            stack.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 16
            ),

            stack.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -16
            ),

            stack.bottomAnchor.constraint(
                equalTo: container.bottomAnchor,
                constant: -16
            )
        ])

        contentStack.addArrangedSubview(
            container
        )
    }
}
