//
//  DailyBoxOfficeHeaderCell.swift
//  BoxOffice
//
//  Created by DONGWOOK SEO on 2023/07/25.
//

import UIKit

protocol HeaderViewHandlerable: AnyObject {
    func headerView(_ movie: DailyBoxOffice, ofSelected headerView: UICollectionReusableView)
}

final class DailyBoxOfficeHeaderCell: UICollectionReusableView {
    // MARK: - Constants
    static let reuseableIdentifier = String(describing: DailyBoxOfficeHeaderCell.self)

    private enum Constants {
        static let topRankedMarkImageName: String = "TopRankMark"

        static let titleLabelFontSize = 20.0
        static let titleLabelTopInset = 15.0
        static let titleLabelLeadingInset = 20.0
        static let titleLabelTrailingInset = 10.0

        static let subTitleLabelFontSize = 15.0
        static let subTitleLabelTopInsetWithTitleLabel = 5.0

        static let rankLabelFontSize = 50.0
        static let rankLabelBackgroundheightWidth = 70.0
        static let rankedMarkWidthHeightSize = 70.0

        static let moviePosterWidth = 150.0
        static let moviePosterHeight = 200.0
    }
    // MARK: - Properties
    weak var delegate: HeaderViewHandlerable?
    private var headerMovie: DailyBoxOffice?
    private var headerMoviePoster: UIImage?

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
        imageView.image = UIImage(named: Constants.topRankedMarkImageName)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
        self.addGestureRecognizer(tapGesture)
        setupLayout()
    }

    @objc private func headerViewTapped() {
        guard let headerMovie else { return }
        delegate?.headerView(headerMovie, ofSelected: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func configureHeader(with movie: DailyBoxOffice, poster: UIImage) {
        headerMovie = movie
        headerMoviePoster = poster
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleLabelTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: Constants.titleLabelLeadingInset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.titleLabelTrailingInset),
        ])
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.subTitleLabelTopInsetWithTitleLabel),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        topRankMark.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topRankMark.widthAnchor.constraint(equalToConstant: Constants.rankedMarkWidthHeightSize),
            topRankMark.heightAnchor.constraint(equalToConstant: Constants.rankedMarkWidthHeightSize),
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
            moviePoster.widthAnchor.constraint(equalToConstant: Constants.moviePosterWidth),
            moviePoster.heightAnchor.constraint(equalToConstant: Constants.moviePosterHeight)
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
