//
//  DailyBoxOfficeViewController.swift
//  BoxOffice
//
//  Created by kjs on 13/01/23.
//

import UIKit

final class DailyBoxOfficeViewController: UIViewController {

    private enum Section {
        case main
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, DailyBoxOffice>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, DailyBoxOffice>

    private var loadingIndicatorView = UIActivityIndicatorView(style: .large)
    private let boxOfficeManager = BoxOfficeAPIManager()
    private var dailyBoxOfficeCollectionView: UICollectionView?
    private var dataSource: DataSource?
    private var movies = [DailyBoxOffice]() {
        didSet {
            applySnapShot()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicatorview()
        setUpUI()
        configureCollectionView()
        configureDataSource()
        fetchBoxOfficeData()
    }

    private func setUpUI() {
        view.backgroundColor = .systemBackground
    }

    private func configureCollectionView() {
        dailyBoxOfficeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        guard let dailyBoxOfficeCollectionView else { return }
        dailyBoxOfficeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dailyBoxOfficeCollectionView)
        dailyBoxOfficeCollectionView.register(DailyBoxOfficeCell.self,
                                              forCellWithReuseIdentifier: DailyBoxOfficeCell.identifier)
        configureCollectionViewLayoutConstraint()
        configureRefreshControl()
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let configuration = UICollectionLayoutListConfiguration(appearance: .plain)

            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        }

        return layout
    }

    private func configureCollectionViewLayoutConstraint() {
        guard let dailyBoxOfficeCollectionView else { return }
        let safeAreaGuide = view.safeAreaLayoutGuide
        dailyBoxOfficeCollectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor).isActive = true
        dailyBoxOfficeCollectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor).isActive = true
        dailyBoxOfficeCollectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor).isActive = true
        dailyBoxOfficeCollectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor).isActive = true
    }

    private func configureDataSource() {
        guard let dailyBoxOfficeCollectionView else { return }
        dataSource = UICollectionViewDiffableDataSource(collectionView: dailyBoxOfficeCollectionView )
        { collectionView, indexPath, movie in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyBoxOfficeCell.identifier,
                                                          for: indexPath) as? DailyBoxOfficeCell
            cell?.accessories = [.disclosureIndicator()]
            cell?.configure(with: movie)

            return cell
        }
    }

    private func fetchBoxOfficeData() {
        let yesterDay = Date.yesterDayDateConvertToString()
        let yesterdayDashExcepted = yesterDay.without("-")

        boxOfficeManager.fetchData(to: BoxOffice.self, endPoint: .boxOffice(targetDate: yesterdayDashExcepted))
        { [weak self] data in
            guard let boxOffice = data as? BoxOffice else { return }
            self?.movies = boxOffice.result.dailyBoxOffices
            DispatchQueue.main.async {
                self?.dailyBoxOfficeCollectionView?.refreshControl?.endRefreshing()
                self?.navigationItem.title = yesterDay
                self?.hideIndicatorView()
            }
        }
    }

    private func applySnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(movies)

        DispatchQueue.main.async {
            self.dataSource?.apply(snapShot)
        }
    }

}

extension DailyBoxOfficeViewController {

    private func window() -> UIWindow {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return UIWindow() }

        return window
    }

    private func showIndicatorview() {
        let window = window()
        loadingIndicatorView.frame = window.frame
        loadingIndicatorView.color = .systemBlue
        window.addSubview(loadingIndicatorView)
        loadingIndicatorView.startAnimating()
    }
    
    private func hideIndicatorView() {
        let window = window()
        let indicatorView = window.subviews.first { $0 is UIActivityIndicatorView }
        guard let indicatorView else { return }
        indicatorView.removeFromSuperview()
    }

    private func configureRefreshControl() {
        guard let dailyBoxOfficeCollectionView else { return }

        dailyBoxOfficeCollectionView.refreshControl = UIRefreshControl()
        dailyBoxOfficeCollectionView.refreshControl?.addTarget(self,
                                                               action: #selector(handleRefreshControl),
                                                               for: .valueChanged)
    }

    @objc private func handleRefreshControl() {
        fetchBoxOfficeData()
    }

}
