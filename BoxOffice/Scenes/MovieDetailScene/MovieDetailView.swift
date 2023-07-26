//
//  MovieDetailView.swift
//  BoxOffice
//
//  Created by 김용재 on 2023/05/16.
//

import UIKit

final class MovieDetailView: UIView {

    private enum Constants {
        static let directorLabelText = "감독"
        static let yearsOfProductionLabelText = "제작년도"
        static let openDateLabelText = "개봉일"
        static let runningTimeLabelText = "상영시간"
        static let movieRatingLabelText = "관람등급"
        static let nationLabelText = "제작국가"
        static let genreLabelText = "장르"
        static let actorsLabelText = "배우"

        static let minuteText = "분"

        static let applicationBackColorName: String = "backgroundColor"

        static let movieImageWidth = 200.0
        static let movieImageHeight = 300.0
        static let movieImageConerRadius = 10.0
        static let movieImageTopInset = 20.0

        static let backGroundDarkViewOpacity: Float = 0.8
        static let cellSeperatorBorderWidth: CGFloat = 2

        static let movieDetailVerticalStackViewSpacing = 4.0
        static let movieDetailVerticalStackViewTopAnchorInset = 20.0
        static let movieDetailVerticalStackViewBottomAnchorInset = 10.0
        static let movieDetailVerticalStackViewLeadingAndTrailingInset = 40.0

        static let keyLabelWidthMultiplierRatio = 0.3
    }

    private let movieDetailScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground

        return scrollView
    }()

    private var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .systemBackground

        return contentView
    }()

    private let movieImageBackgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: Constant.noneImageCallName )
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private var backgroundDarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.opacity = Constants.backGroundDarkViewOpacity
        return view
    }()

    private let moviePosterView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: Constant.noneImageCallName )
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.movieImageConerRadius
        imageView.clipsToBounds = true

        return imageView
    }()

    private var stackSeperatorView: UIView {
        let seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.widthAnchor.constraint(equalToConstant: Constants.cellSeperatorBorderWidth).isActive = true
        seperator.backgroundColor = UIColor(named: "backgroundColor")
        return seperator
    }
    
    private let directorKeyLabel = MovieDetailKeyLabel(text: Constants.directorLabelText)
    private let yearOfProductionKeyLabel = MovieDetailKeyLabel(text: Constants.yearsOfProductionLabelText)
    private let openDateKeyLabel = MovieDetailKeyLabel(text: Constants.openDateLabelText)
    private let runningTimeKeyLabel = MovieDetailKeyLabel(text: Constants.runningTimeLabelText)
    private let movieRatingKeyLabel = MovieDetailKeyLabel(text: Constants.movieRatingLabelText)
    private let nationKeyLabel = MovieDetailKeyLabel(text: Constants.nationLabelText)
    private let genreKeyLabel = MovieDetailKeyLabel(text: Constants.genreLabelText)
    private let actorsKeyLabel = MovieDetailKeyLabel(text: Constants.actorsLabelText)

    private let directorValueLabel = MovieDetailValueLabel()
    private let yearOfProductionValueLabel = MovieDetailValueLabel()
    private let openDateValueLabel = MovieDetailValueLabel()
    private let runningTimeValueLabel = MovieDetailValueLabel()
    private let movieRatingValueLabel = MovieDetailValueLabel()
    private let nationValueLabel = MovieDetailValueLabel()
    private let genreValueLabel = MovieDetailValueLabel()
    private let actorsValueLabel = MovieDetailValueLabel()

    private lazy var directorInfoStackView = MovieDetailHorizontalStackView(
        arrangedSubviews: [directorKeyLabel, stackSeperatorView, directorValueLabel]
    )
    private lazy var yearOfProductionInfoStackView = MovieDetailHorizontalStackView(
        arrangedSubviews: [yearOfProductionKeyLabel, stackSeperatorView, yearOfProductionValueLabel]
    )
    private lazy var openDateInfoStackView = MovieDetailHorizontalStackView(
        arrangedSubviews: [openDateKeyLabel, stackSeperatorView, openDateValueLabel]
    )
    private lazy var runningTimeInfoStackView = MovieDetailHorizontalStackView(
        arrangedSubviews: [runningTimeKeyLabel, stackSeperatorView, runningTimeValueLabel]
    )
    private lazy var movieRatingInfoStackView = MovieDetailHorizontalStackView(
        arrangedSubviews: [movieRatingKeyLabel, stackSeperatorView, movieRatingValueLabel]
    )
    private lazy var nationInfoStackView = MovieDetailHorizontalStackView(
        arrangedSubviews: [nationKeyLabel, stackSeperatorView, nationValueLabel]
    )
    private lazy var genreInfoStackView = MovieDetailHorizontalStackView(
        arrangedSubviews: [genreKeyLabel, stackSeperatorView, genreValueLabel]
    )
    private lazy var actorsInfoStackView = MovieDetailHorizontalStackView(
        arrangedSubviews: [actorsKeyLabel, stackSeperatorView, actorsValueLabel]
    )

    private lazy var movieDetailVerticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [directorInfoStackView,
                               yearOfProductionInfoStackView,
                               openDateInfoStackView,
                               runningTimeInfoStackView,
                               movieRatingInfoStackView,
                               nationInfoStackView,
                               genreInfoStackView,
                               actorsInfoStackView]
        )
        stackView.alignment = .fill
        stackView.spacing = Constants.movieDetailVerticalStackViewSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        movieDetailScrollView.backgroundColor = UIColor(named: Constants.applicationBackColorName)
        contentView.backgroundColor = UIColor(named: Constants.applicationBackColorName)
        configureHierachy()
        configureLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureImage(with imageData: Data) {
        let poster = UIImage(data: imageData)
        if let poster, poster.size.width >= poster.size.height {
            moviePosterView.contentMode = .scaleAspectFill
        }
        DispatchQueue.main.async {
            self.moviePosterView.image = UIImage(data: imageData)
            self.movieImageBackgroundView.image = self.moviePosterView.image
        }
    }

    func configure(with movie: MovieDetailViewController.MovieDetailModel) {
        directorValueLabel.text = movie.director.description
        yearOfProductionValueLabel.text = movie.yearOfProduction
        openDateValueLabel.text = movie.openDate.yearMonthDaySplitDash
        runningTimeValueLabel.text = movie.runningTime + Constants.minuteText
        movieRatingValueLabel.text = movie.movieRating ?? Constant.noneText
        nationValueLabel.text = movie.nation ?? Constant.noneText
        genreValueLabel.text = movie.genres.description
        actorsValueLabel.text = movie.actors.description
    }

    private func configureHierachy() {
        addSubview(movieDetailScrollView)
        movieDetailScrollView.addSubview(contentView)
        contentView.addSubview(movieImageBackgroundView)
        contentView.addSubview(backgroundDarkView)
        contentView.addSubview(moviePosterView)
        contentView.addSubview(movieDetailVerticalStackView)
    }

    private func configureLayoutConstraints() {
        configureScrollViewLayoutConstraint()
        configureContentViewLayoutConstraint()
        configureMovieImageViewLayoutConstraint()
        configureMoviePosterBackgroundView()
        configureMovieDetailVerticalStackViewLayoutConstraint()
        configureKeyLabelayoutContraint()
    }

    private func configureScrollViewLayoutConstraint() {
        NSLayoutConstraint.activate([
            movieDetailScrollView.topAnchor.constraint(equalTo: topAnchor),
            movieDetailScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieDetailScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieDetailScrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configureContentViewLayoutConstraint() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: movieDetailScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: movieDetailScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: movieDetailScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: movieDetailScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: movieDetailScrollView.widthAnchor)
        ])
    }

    private func configureMovieImageViewLayoutConstraint() {
        NSLayoutConstraint.activate([
            moviePosterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.movieImageTopInset),
            moviePosterView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            moviePosterView.widthAnchor.constraint(equalToConstant: Constants.movieImageWidth),
            moviePosterView.heightAnchor.constraint(equalToConstant: Constants.movieImageHeight)
        ])
    }

    private func configureMoviePosterBackgroundView() {
        NSLayoutConstraint.activate([
            movieImageBackgroundView.topAnchor.constraint(equalTo: moviePosterView.topAnchor),
            movieImageBackgroundView.heightAnchor.constraint(equalToConstant: Constants.movieImageHeight),
            movieImageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImageBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundDarkView.topAnchor.constraint(equalTo: movieImageBackgroundView.topAnchor),
            backgroundDarkView.leadingAnchor.constraint(equalTo: movieImageBackgroundView.leadingAnchor),
            backgroundDarkView.trailingAnchor.constraint(equalTo: movieImageBackgroundView.trailingAnchor),
            backgroundDarkView.bottomAnchor.constraint(equalTo: movieImageBackgroundView.bottomAnchor)
        ])
    }

    private func configureMovieDetailVerticalStackViewLayoutConstraint() {
        NSLayoutConstraint.activate([
            movieDetailVerticalStackView.topAnchor.constraint(equalTo: moviePosterView.bottomAnchor, constant: Constants.movieDetailVerticalStackViewTopAnchorInset),
            movieDetailVerticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.movieDetailVerticalStackViewLeadingAndTrailingInset),
            movieDetailVerticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.movieDetailVerticalStackViewLeadingAndTrailingInset),
            movieDetailVerticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.movieDetailVerticalStackViewBottomAnchorInset)
        ])
    }

    private func configureKeyLabelayoutContraint() {
        [directorKeyLabel,
         yearOfProductionKeyLabel,
         openDateKeyLabel,
         runningTimeKeyLabel,
         movieRatingKeyLabel,
         nationKeyLabel,
         genreKeyLabel,
         actorsKeyLabel].forEach { label in
            label.widthAnchor.constraint(
                equalTo: movieDetailVerticalStackView.widthAnchor,
                multiplier: Constants.keyLabelWidthMultiplierRatio).isActive = true
        }
    }

}
