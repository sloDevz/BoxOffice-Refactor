//
//  DailyBoxOfficeHeaderCell.swift
//  BoxOffice
//
//  Created by DONGWOOK SEO on 2023/07/25.
//

import UIKit

final class DailyBoxOfficeHeaderCell: UICollectionReusableView {
    // MARK: - Constants
    static let reuseableIdentifier = String(describing: DailyBoxOfficeHeaderCell.self)

    private enum Constants {
        static let titleLabelFontSize = 20.0
        static let titleLabelBackgroundheight = 30.0
        static let titleLabelBackgroundWidth = 350.0

        static let rankLabelFontSize = 50.0
        static let rankLabelBackgroundheightWidth = 70.0
    }
    // MARK: - Properties

    // MARK: - UI Components
    private let titleLabelBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.titleLabelBackgroundheight / 2
        view.layer.opacity = 0.5
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.titleLabelFontSize)
        label.textAlignment = .center
        return label
    }()
    private let rankLabelBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.rankLabelBackgroundheightWidth / 2
        view.layer.opacity = 0.5
        return view
    }()
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.rankLabelFontSize)
        return label
    }()
    private let movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func configureHeader(movie: HeaderMovie) {
        rankLabel.text = movie.rank
        titleLabel.text = movie.title
        movieImage.image = movie.poster
    }
    // MARK: - Private
    private func setupLayout() {
        addSubview(movieImage)
        addSubview(titleLabelBackground)
        addSubview(titleLabel)
        addSubview(rankLabelBackground)
        addSubview(rankLabel)

        movieImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            movieImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleLabelBackground.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: titleLabelBackground.trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: titleLabelBackground.centerYAnchor)
        ])
        titleLabelBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabelBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            titleLabelBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabelBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            titleLabelBackground.heightAnchor.constraint(equalToConstant: Constants.titleLabelBackgroundheight)
        ])

        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankLabel.centerXAnchor.constraint(equalTo: rankLabelBackground.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: rankLabelBackground.centerYAnchor)
        ])
        rankLabelBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankLabelBackground.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            rankLabelBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            rankLabelBackground.heightAnchor.constraint(equalToConstant: Constants.rankLabelBackgroundheightWidth),
            rankLabelBackground.widthAnchor.constraint(equalToConstant: Constants.rankLabelBackgroundheightWidth)
        ])
    }


}
