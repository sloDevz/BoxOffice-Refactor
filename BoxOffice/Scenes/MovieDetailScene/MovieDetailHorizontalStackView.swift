//
//  MovieDetailHorizontalStackView.swift
//  BoxOffice
//
//  Created by 김용재 on 2023/05/16.
//

import UIKit

final class MovieDetailHorizontalStackView: UIStackView {

    private enum Constants {
        static let topBottomlayoutMargins = 8.0
        static let rightLeftlayoutMargins = 3.0
        static let detailContentCellColorName = "DetialLabelCellColor"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(views: UIView...) {
        self.init(frame: CGRect())
        configureUI()
    }

    private func configureUI() {
        self.layoutMargins = .init(
            top: Constants.topBottomlayoutMargins,
            left: Constants.rightLeftlayoutMargins,
            bottom: Constants.topBottomlayoutMargins,
            right: Constants.rightLeftlayoutMargins
        )
        self.isLayoutMarginsRelativeArrangement = true
        self.alignment = .fill
        self.spacing = 10
        self.axis = .horizontal
        self.backgroundColor = UIColor(named: Constants.detailContentCellColorName)
    }

}
