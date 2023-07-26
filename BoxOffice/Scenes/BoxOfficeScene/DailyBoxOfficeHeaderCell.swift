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
        static let subTitleLabelFontSize = 15.0
        static let titleLabelBackgroundheight = 30.0
        static let titleLabelBackgroundWidth = 350.0

        static let rankLabelFontSize = 50.0
        static let rankLabelBackgroundheightWidth = 70.0
    }
    // MARK: - Properties

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.titleLabelFontSize)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.subTitleLabelFontSize)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    private let backgroundDarkView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.7
        return view
    }()
    private let topRankMark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TopRankMark")
        return imageView
    }()
    private let movieImageBackground: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    private let moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
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
    func configureHeader(with movie: DailyBoxOffice, poster: UIImage) {
        configureTitleAndSubTitle(with: movie.movieName)
        movieImageBackground.image = poster
        moviePoster.image = poster
    }
    // MARK: - Private
    private func setupLayout() {
        addSubview(movieImageBackground)
        addSubview(backgroundDarkView)
        addSubview(moviePoster)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(topRankMark)

        movieImageBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieImageBackground.topAnchor.constraint(equalTo: topAnchor),
            movieImageBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImageBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            movieImageBackground.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        topRankMark.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topRankMark.widthAnchor.constraint(equalToConstant: 70),
            topRankMark.heightAnchor.constraint(equalToConstant: 70),
            topRankMark.topAnchor.constraint(equalTo: topAnchor),
            topRankMark.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        backgroundDarkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundDarkView.topAnchor.constraint(equalTo: topAnchor),
            backgroundDarkView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundDarkView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundDarkView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviePoster.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviePoster.centerYAnchor.constraint(equalTo: centerYAnchor),
            moviePoster.widthAnchor.constraint(equalToConstant: 150),
            moviePoster.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configureTitleAndSubTitle(with title: String) {
        let slpitedString = title.split(separator:":")
        let titles = slpitedString.map { string in
            string.trimmingCharacters(in: .whitespaces)
        }
        let movieTitle = titles.first
        let subTitle = titles.last
        titleLabel.text = movieTitle
        subTitleLabel.text = subTitle
    }


}
