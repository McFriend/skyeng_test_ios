//
//  SearchViewModel.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift
class SearchViewModel: ViewModel {
    var searchText = BehaviorRelay<String?>(value: "")
    var searchPlaceholder = BehaviorRelay<String?>(value: "SEARCH_PLACEHOLDER".localized)
    var results = BehaviorRelay<[SearchResultTableViewCellViewModel]?>(value: [])
    var apiManager = SearchApiManager()
    var page = BehaviorRelay<Int>(value: 1)
    var pageSize = BehaviorRelay<Int>(value: 10)
    var loadedAll = BehaviorRelay<Bool>(value: false)
    
    override func configure() {
        super.configure()
        searchText.subscribe(onNext: { [unowned self] _ in
            self.loadedAll.accept(false)
            self.results.accept([])
            self.page.accept(1)
        }).disposed(by: bag)
        
        Observable.combineLatest(searchText, page, pageSize).flatMapLatest({ [unowned self] in
            self.apiManager.performSearch(query: $0 ?? "", page: $1, pageSize: $2)
        }).do(onNext: { [unowned self] in
            self.loadedAll.accept($0.isEmpty)
        }).map({[unowned self] in
            (self.results.value ?? []) + $0.map({
                SearchResultTableViewCellViewModel(searchText: self.searchText.value, title: $0.text, subtitle: $0.meanings.map({ meaning in
                    meaning.translation.text
                    }).joined(separator: ", "), previewURL: $0.meanings.first?.previewUrl)
            })
        })
            .bind(to: results)
            .disposed(by: bag)
    }
}
