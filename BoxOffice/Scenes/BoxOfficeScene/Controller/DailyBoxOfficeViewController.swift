//
//  DailyBoxOfficeViewController.swift
//  BoxOffice
//
//  Created by kjs on 13/01/23.
//

import UIKit

final class DailyBoxOfficeViewController: UIViewController {

    // MARK: - Constant
    private enum Section {
        case main
    }
    private enum Constant {
        static let headerViewElementKind: String = "section-header"
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, DailyBoxOffice>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, DailyBoxOffice>

    private let loadingIndicatorView = UIActivityIndicatorView(style: .large)
    private let boxOfficeManager = NetworkAPIManager()
    private let networkDispatcher = NetworkDispatcher()
    private lazy var dataSource: DataSource = configureDataSource()
    private lazy var dailyBoxOfficeCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(
            DailyBoxOfficeCell.self,
            forCellWithReuseIdentifier: DailyBoxOfficeCell.identifier
        )
        collectionView.register(
            DailyBoxOfficeHeaderCell.self,
            forSupplementaryViewOfKind: Constant.headerViewElementKind,
            withReuseIdentifier: DailyBoxOfficeHeaderCell.reuseableIdentifier
        )
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    private var movies = [DailyBoxOffice]()
    private var headerMovie: DailyBoxOffice?
    private var headerMoviePoster: UIImage? {
        didSet {
            applySnapShot()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureCollectionView()
        addIndicatorview()
        fetchBoxOfficeData()
    }

    private func configureAttributes() {
        view.backgroundColor = .systemBackground
    }

    private func configureCollectionView() {
        view.addSubview(dailyBoxOfficeCollectionView)
        configureCollectionViewLayoutConstraint()
        configureRefreshControl()
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.5)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: Constant.headerViewElementKind,
                alignment: .top
            )
            let listSection = NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: layoutEnvironment)
            listSection.boundarySupplementaryItems = [header]

            return listSection
        }

        return layout
    }

    private func configureCollectionViewLayoutConstraint() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        dailyBoxOfficeCollectionView.leadingAnchor.constraint(
            equalTo: safeAreaGuide.leadingAnchor).isActive = true
        dailyBoxOfficeCollectionView.trailingAnchor.constraint(
            equalTo: safeAreaGuide.trailingAnchor).isActive = true
        dailyBoxOfficeCollectionView.bottomAnchor.constraint(
            equalTo: safeAreaGuide.bottomAnchor).isActive = true
        dailyBoxOfficeCollectionView.topAnchor.constraint(
            equalTo: safeAreaGuide.topAnchor).isActive = true
    }

    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: dailyBoxOfficeCollectionView)
        { collectionView, indexPath, movie in

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DailyBoxOfficeCell.identifier,
                for: indexPath) as? DailyBoxOfficeCell
            
            cell?.accessories = [.disclosureIndicator()]
            cell?.configure(with: movie)

            return cell
        }
        dataSource.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DailyBoxOfficeHeaderCell.reuseableIdentifier,
                for: indexPath) as? DailyBoxOfficeHeaderCell else
            {
                fatalError("Cannot create header view")
            }
            if let movie = self.headerMovie, let poster = self.headerMoviePoster {
                supplementaryView.configureHeader(with: movie, poster: poster)
            }
            return supplementaryView
        }
        return dataSource
    }

    private func fetchBoxOfficeData() {
        let yesterDay = Date.yesterDayDateConvertToString()
        let yesterdayDashExcepted = yesterDay.without("-")
        let boxOfficeEndPoint = BoxOfficeAPIEndpoint.boxOffice(targetDate: yesterdayDashExcepted)

        Task{
            do {
                let decodedData = try await boxOfficeManager.fetchData(to: BoxOffice.self, endPoint: boxOfficeEndPoint)
                guard let boxOffice = decodedData as? BoxOffice else { return }

                var decodedMovies = boxOffice.result.dailyBoxOffices
                let firstRankedMovie = decodedMovies.removeFirst()

                let imageURLEndPoint = SearchImageAPIEndPoint.moviePoster(name: firstRankedMovie.movieName)
                let decodedImageURLData = try await boxOfficeManager.fetchData(
                    to: SearchedImage.self,
                    endPoint: imageURLEndPoint
                )
                guard let imageURLModel = decodedImageURLData as? SearchedImage else { return }
                guard let imageURLString = imageURLModel.imageURL else { return }
                guard let imageURL = URL(string: imageURLString) else { return }
                let imageURLRequest = URLRequest(url: imageURL)
                let imageResult = try await networkDispatcher.performRequest(imageURLRequest)

                movies = decodedMovies
                headerMovie = firstRankedMovie
                switch imageResult {
                case .success(let data):
                    headerMoviePoster = UIImage(data: data)
                case .failure(let error):
                    print(error.errorDescription)
                }


            } catch {
                print(error.localizedDescription)
            }
            navigationItem.title = yesterDay
            removeIndicatorView()
            endRefresh()
        }
    }

    private func applySnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(movies)
        dataSource.apply(snapShot)
    }

}

extension DailyBoxOfficeViewController {

    private func addIndicatorview() {
        loadingIndicatorView.frame = view.frame
        loadingIndicatorView.color = .systemBlue
        view.addSubview(loadingIndicatorView)
        loadingIndicatorView.startAnimating()
    }
    
    private func removeIndicatorView() {
        loadingIndicatorView.removeFromSuperview()
    }

    private func configureRefreshControl() {
        dailyBoxOfficeCollectionView.refreshControl = UIRefreshControl()
        dailyBoxOfficeCollectionView.refreshControl?.addTarget(
            self,
            action: #selector(handleRefreshControl),
            for: .valueChanged
        )
    }

    private func endRefresh() {
        dailyBoxOfficeCollectionView.refreshControl?.endRefreshing()
    }

    @objc private func handleRefreshControl() {
        fetchBoxOfficeData()
    }

}

extension DailyBoxOfficeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        let movieDetailViewController = MovieDetailViewController(
            movie: movie,
            boxOfficeAPIManager: boxOfficeManager,
            networkDispatcher: networkDispatcher
        )
        movieDetailViewController.navigationItem.title = movie.movieName
        dailyBoxOfficeCollectionView.deselectItem(at: indexPath, animated: true)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }

}
