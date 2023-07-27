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
        static let topRankedMarkImageName = "TopRankMark"

        static let todayKeyLabelText = "Today"
        static let totalKeyLabelText = "Total"
        static let labelSkeletonText = "-"
        static let audianceValueUnitText = " 명"

        static let upSymbolName: String = "UPArrowSymbol"
        static let newSymbolName: String = "NewSymbol"

        static let backgroundDarkViewOpacity: Float = 0.8

        static let titleLabelFontSize = 24.0
        static let titleLabelTopInset = 15.0
        static let titleLabelLeadingInset = 20.0
        static let titleLabelTrailingInset = 10.0

        static let subTitleLabelFontSize = 15.0
        static let subTitleLabelTopInsetWithTitleLabel = 5.0

        static let newMarkingImageWidthHeight = 25.0
        static let newMarkingImageLeadingInset = 5.0
        static let newMarkingImageTopInset = 10.0

        static let rankingChangeImageWidht = 58.0
        static let rankingChangeImageHeight = 50.0
        static let rankingChangeLabelFontSIze = 18.0
        static let rankingChangeLabelTopInset = 7.0

        static let seperatorLineHeight = 1.0
        static let seperatorLineTopInset = 30.0
        static let seperatorLineLeadingTrailingInset = 10.0

        static let audianceKeyFontSize = 10.0
        static let audianceKeyLabelWidth = 30.0
        static let audianceValueFontSize = 17.0

        static let totalAudianceKeyLabelTopInset = 20.0
        static let totalAudianceValueLabelTopInset = 2.0
        static let audianceLabelBackgroundSideInset = 7.0
        static let audianceLabelBackgroundVerticalInset = 2.0
        static let audianceValueLabelLeadingInset = 20.0
        static let audianceLabelGroupOffset = 10.0
        static let todayAudianceValueLabelTopInset = 2.0

        static let UISideLayoutGuideInset = 25.0

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
    private let rankingChangeImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Constants.upSymbolName)
        return view
    }()
    private let newMarkingImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Constants.newSymbolName)
        return view
    }()
    private let rankingChangeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.rankingChangeLabelFontSIze)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private let audianceTotalKeyLabelBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = Constants.audianceKeyFontSize/2
        return view
    }()
    private let audianceTodayKeyLabelBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = Constants.audianceKeyFontSize/2
        return view
    }()
    private let seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.subTitleLabelFontSize/2
        return view
    }()
    private let audianceSeperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.opacity = 0.5
        view.layer.cornerRadius = Constants.subTitleLabelFontSize/2
        return view
    }()
    private let todayAudianceKeyLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.audianceKeyFontSize)
        label.textColor = .white
        label.text = Constants.todayKeyLabelText
        label.textAlignment = .center
        return label
    }()
    private let todayAudianceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.audianceValueFontSize)
        label.textColor = .white
        label.text = Constants.labelSkeletonText
        label.textAlignment = .right
        return label
    }()
    private let totalAudianceKeyLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.audianceKeyFontSize)
        label.textColor = .white
        label.text = Constants.totalKeyLabelText
        label.textAlignment = .center
        return label
    }()
    private let totalAudianceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.audianceValueFontSize)
        label.textColor = .white
        label.text = Constants.labelSkeletonText
        label.textAlignment = .right
        return label
    }()
    private let backgroundDarkView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = Constants.backgroundDarkViewOpacity
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
        configureAudianceLabelValuse(with: movie)
        setRankingChangesAndNewSymbol(movie)
    }
    // MARK: - Private
    private func setupLayout() {
        addSubview(movieImageBackground)
        addSubview(backgroundDarkView)
        addSubview(moviePoster)
        addSubview(topRankMark)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(newMarkingImage)
        addSubview(rankingChangeImage)
        addSubview(rankingChangeLabel)
        addSubview(seperatorLine)
        addSubview(audianceTotalKeyLabelBackground)
        addSubview(totalAudianceKeyLabel)
        addSubview(totalAudianceValueLabel)
        addSubview(audianceSeperatorLine)
        addSubview(audianceTodayKeyLabelBackground)
        addSubview(todayAudianceKeyLabel)
        addSubview(todayAudianceValueLabel)

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
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.titleLabelTrailingInset),
        ])
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.subTitleLabelTopInsetWithTitleLabel),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        newMarkingImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newMarkingImage.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -Constants.newMarkingImageTopInset),
            newMarkingImage.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.newMarkingImageLeadingInset),
            newMarkingImage.widthAnchor.constraint(equalToConstant: Constants.newMarkingImageWidthHeight),
            newMarkingImage.heightAnchor.constraint(equalToConstant: Constants.newMarkingImageWidthHeight)
        ])
        rankingChangeImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankingChangeImage.widthAnchor.constraint(equalToConstant: Constants.rankingChangeImageWidht),
            rankingChangeImage.heightAnchor.constraint(equalToConstant: Constants.rankingChangeImageHeight),
            rankingChangeImage.bottomAnchor.constraint(equalTo: seperatorLine.topAnchor),
            rankingChangeImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -Constants.UISideLayoutGuideInset)
        ])
        rankingChangeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankingChangeLabel.centerXAnchor.constraint(equalTo: rankingChangeImage.centerXAnchor),
            rankingChangeLabel.topAnchor.constraint(equalTo: rankingChangeImage.topAnchor, constant: Constants.rankingChangeLabelTopInset)
        ])
        seperatorLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seperatorLine.heightAnchor.constraint(equalToConstant: Constants.seperatorLineHeight),
            seperatorLine.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: Constants.seperatorLineTopInset),
            seperatorLine.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor, constant: -Constants.seperatorLineLeadingTrailingInset),
            seperatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.seperatorLineLeadingTrailingInset)
        ])
        totalAudianceKeyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalAudianceKeyLabel.widthAnchor.constraint(equalToConstant: Constants.audianceKeyLabelWidth),
            totalAudianceKeyLabel.topAnchor.constraint(equalTo: seperatorLine.bottomAnchor, constant: Constants.totalAudianceKeyLabelTopInset),
            totalAudianceKeyLabel.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
        ])
        audianceTotalKeyLabelBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            audianceTotalKeyLabelBackground.topAnchor.constraint(equalTo: totalAudianceKeyLabel.topAnchor, constant: -Constants.audianceLabelBackgroundVerticalInset),
            audianceTotalKeyLabelBackground.leadingAnchor.constraint(equalTo: totalAudianceKeyLabel.leadingAnchor, constant: -Constants.audianceLabelBackgroundSideInset),
            audianceTotalKeyLabelBackground.bottomAnchor.constraint(equalTo: totalAudianceKeyLabel.bottomAnchor, constant: Constants.audianceLabelBackgroundVerticalInset),
            audianceTotalKeyLabelBackground.trailingAnchor.constraint(equalTo: totalAudianceKeyLabel.trailingAnchor, constant: Constants.audianceLabelBackgroundSideInset)
        ])
        totalAudianceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalAudianceValueLabel.centerYAnchor.constraint(equalTo: totalAudianceKeyLabel.centerYAnchor, constant: Constants.totalAudianceValueLabelTopInset),
            totalAudianceValueLabel.leadingAnchor.constraint(equalTo: totalAudianceKeyLabel.trailingAnchor, constant: Constants.audianceValueLabelLeadingInset),
            totalAudianceValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.UISideLayoutGuideInset)
        ])
        audianceSeperatorLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            audianceSeperatorLine.topAnchor.constraint(equalTo: totalAudianceValueLabel.bottomAnchor, constant: Constants.audianceLabelGroupOffset),
            audianceSeperatorLine.heightAnchor.constraint(equalToConstant: Constants.seperatorLineHeight),
            audianceSeperatorLine.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor, constant: -Constants.seperatorLineLeadingTrailingInset),
            audianceSeperatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.seperatorLineLeadingTrailingInset)
        ])
        todayAudianceKeyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todayAudianceKeyLabel.widthAnchor.constraint(equalToConstant: Constants.audianceKeyLabelWidth),
            todayAudianceKeyLabel.topAnchor.constraint(equalTo: audianceSeperatorLine.bottomAnchor, constant: Constants.audianceLabelGroupOffset + 5),
            todayAudianceKeyLabel.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
        ])
        audianceTodayKeyLabelBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            audianceTodayKeyLabelBackground.topAnchor.constraint(equalTo: todayAudianceKeyLabel.topAnchor, constant: -Constants.audianceLabelBackgroundVerticalInset),
            audianceTodayKeyLabelBackground.leadingAnchor.constraint(equalTo: todayAudianceKeyLabel.leadingAnchor, constant: -Constants.audianceLabelBackgroundSideInset),
            audianceTodayKeyLabelBackground.bottomAnchor.constraint(equalTo: todayAudianceKeyLabel.bottomAnchor, constant: Constants.audianceLabelBackgroundVerticalInset),
            audianceTodayKeyLabelBackground.trailingAnchor.constraint(equalTo: todayAudianceKeyLabel.trailingAnchor, constant: Constants.audianceLabelBackgroundSideInset)
        ])
        todayAudianceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todayAudianceValueLabel.centerYAnchor.constraint(equalTo: todayAudianceKeyLabel.centerYAnchor),
            todayAudianceValueLabel.leadingAnchor.constraint(equalTo: todayAudianceKeyLabel.trailingAnchor, constant: Constants.audianceValueLabelLeadingInset),
            todayAudianceValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.UISideLayoutGuideInset)
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

    private func setRankingChangesAndNewSymbol(_ movie: DailyBoxOffice) {
        let new = movie.rankOldAndNew
        let changes = Int(movie.dailyRankChanges)
        if new == .new {
            newMarkingImage.isHidden = false
        } else {
            newMarkingImage.isHidden = true
        }
        if let changes, changes > 0 {
            rankingChangeImage.isHidden = false
            rankingChangeLabel.text = String(changes)
        } else {
            rankingChangeImage.isHidden = true
            rankingChangeLabel.text = ""
        }
    }

    private func configureAudianceLabelValuse(with movie: DailyBoxOffice) {
        let todayString = movie.audienceCount
        let totalString = movie.audienceAccumulation

        guard let todayInt = Int(todayString),
              let totalInt = Int(totalString) else { return }

        let today = todayInt.decimalizedString
        let total = totalInt.decimalizedString

        todayAudianceValueLabel.text = today + Constants.audianceValueUnitText
        totalAudianceValueLabel.text = total + Constants.audianceValueUnitText
    }

    private func configureTitleAndSubTitle(with title: String) {
        let slpitedString = title.split(separator:":")
        var titles = slpitedString.map { string in
            string.trimmingCharacters(in: .whitespaces)
        }
        let movieTitle = titles.removeFirst()
        let subTitle = titles.last
        titleLabel.text = movieTitle
        subTitleLabel.text = subTitle ?? " "
    }

    private func generateRankChangesAttributedText(
        _ text: String,
        with image: UIImage?) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image

        let rankChangesAttributedText = NSMutableAttributedString(attachment: attachment)
        let text = NSAttributedString(string: text)
        rankChangesAttributedText.append(text)

        return rankChangesAttributedText
    }
}
