//
//  CharacterCell.swift
//  RickAndMortyShow
//
//  Created by Sumit Gosai on 12/05/26.
//
import UIKit


import UIKit

final class CharacterCell:
UITableViewCell {

    static let reuseIdentifier =
        "CharacterCell"

    // MARK: - Dependencies

    private var imageLoader:
        ImageLoaderProtocol?

    private var imageTaskID: Int?

    // MARK: - UI

    private let avatarImageView =
        UIImageView()

    private let nameLabel =
        UILabel()

    private let subtitleLabel =
        UILabel()

    private let favoriteButton =
        UIButton(type: .system)
    
    var onFavoriteTap: (() -> Void)?

    // MARK: - Init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {

        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()

        imageLoader?.cancelLoad(
            imageTaskID
        )

        imageTaskID = nil

        avatarImageView.image =
            UIImage(
                systemName:
                    "person.crop.circle"
            )
    }

    // MARK: - Configure

    func configure(
        with character: Character,
        isFavorite: Bool,
        imageLoader: ImageLoaderProtocol
    ) {

        self.imageLoader = imageLoader

        nameLabel.text =
            character.name

        subtitleLabel.text =
            "\(character.species ?? "") • \(character.status ?? "")"

        favoriteButton.setImage(
            UIImage(
                systemName:
                    isFavorite
                    ? "heart.fill"
                    : "heart"
            ),
            for: .normal
        )

        avatarImageView.setRemoteImage(
            id: character.id,
            urlString: character.image,
            imageLoader: imageLoader
        ) { [weak self] taskID in

            self?.imageTaskID = taskID
        }
    }

    // MARK: - UI Setup

    private func setupUI() {

        backgroundColor =
            .systemBackground

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.layer.cornerRadius = 30
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill

        nameLabel.font =
            .preferredFont(
                forTextStyle: .headline
            )

        subtitleLabel.font =
            .preferredFont(
                forTextStyle: .subheadline
            )

        subtitleLabel.textColor =
            .secondaryLabel

        contentView.addSubview(
            avatarImageView
        )

        contentView.addSubview(
            nameLabel
        )

        contentView.addSubview(
            subtitleLabel
        )

        contentView.addSubview(
            favoriteButton
        )

        NSLayoutConstraint.activate([

            avatarImageView.leadingAnchor.constraint(
                equalTo:
                    contentView.leadingAnchor,
                constant: 16
            ),

            avatarImageView.centerYAnchor.constraint(
                equalTo:
                    contentView.centerYAnchor
            ),

            avatarImageView.widthAnchor.constraint(
                equalToConstant: 60
            ),

            avatarImageView.heightAnchor.constraint(
                equalToConstant: 60
            ),

            nameLabel.leadingAnchor.constraint(
                equalTo:
                    avatarImageView.trailingAnchor,
                constant: 16
            ),

            nameLabel.topAnchor.constraint(
                equalTo:
                    avatarImageView.topAnchor
            ),

            subtitleLabel.leadingAnchor.constraint(
                equalTo:
                    nameLabel.leadingAnchor
            ),

            subtitleLabel.topAnchor.constraint(
                equalTo:
                    nameLabel.bottomAnchor,
                constant: 4
            ),

            favoriteButton.trailingAnchor.constraint(
                equalTo:
                    contentView.trailingAnchor,
                constant: -16
            ),

            favoriteButton.centerYAnchor.constraint(
                equalTo:
                    contentView.centerYAnchor
            )
        ])
        favoriteButton.addTarget(
            self,
            action: #selector(
                didTapFavorite
            ),
            for: .touchUpInside
        )
    }
}

extension CharacterCell {
    
    @objc
    private func didTapFavorite() {
        onFavoriteTap?()
    }
}
