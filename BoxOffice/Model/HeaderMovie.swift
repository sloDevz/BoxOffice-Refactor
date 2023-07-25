//
//  HeaderMovie.swift
//  BoxOffice
//
//  Created by DONGWOOK SEO on 2023/07/25.
//

import UIKit

struct HeaderMovie {
    var title: String
    var rank: String
    var poster: UIImage

    init(title: String = "-", rank: String = "-", poster: UIImage? = nil) {
        self.title = title
        self.rank = rank
        self.poster = poster ?? UIImage(systemName: "photo")!
    }
}
