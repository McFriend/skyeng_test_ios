//
//  SearchViewModel.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
import RxRelay
class SearchViewModel: ViewModel {
    var searchText = BehaviorRelay<String?>(value: "")
    var searchPlaceholder = BehaviorRelay<String?>(value: "SEARCH_PLACEHOLDER".localized)
    var results = BehaviorRelay<[SearchResultTableViewCellViewModel]?>(value: [])
    
    override func configure() {
        super.configure()
        results.accept([.init(searchText: searchText, title: BehaviorRelay<String?>(value: "Title"), subtitle: BehaviorRelay<String?>(value: "Subtitle"), previewURL: BehaviorRelay<String?>(value: "//d2zkmv5t5kao9.cloudfront.net/images/92967cae8a532f7cb3b92138a78d3636.jpeg?w=96&h=72"))])
    }
}
