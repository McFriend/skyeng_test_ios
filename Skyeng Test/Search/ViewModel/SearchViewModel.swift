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
    var title = BehaviorRelay<String?>(value: "SEARCH_TITLE".localized)
    var searchText = BehaviorRelay<String?>(value: "")
    var searchPlaceholder = BehaviorRelay<String?>(value: "SEARCH_PLACEHOLDER".localized)
    var results = BehaviorRelay<[WordModel]?>(value: [])
    var page = BehaviorRelay<Int>(value: 1)
    var pageSize = BehaviorRelay<Int>(value: 10)
    var loadedAll = BehaviorRelay<Bool>(value: false)
    var apiManager: SearchApiManagerProtocol

    init(apiManager: SearchApiManagerProtocol = SearchApiManager()) {
        self.apiManager = apiManager
        super.init()
    }
    
    override func configure() {
        super.configure()
        searchText.subscribe(onNext: { [unowned self] _ in
            self.loadedAll.accept(false)
            self.results.accept([])
            self.page.accept(1)
        }).disposed(by: bag)
        
        Observable.combineLatest(searchText, page, pageSize).flatMapLatest({ [unowned self] in
            self.performSearch(query: $0 ?? "", page: $1, pageSize: $2)
        }).do(onNext: { [unowned self] in
            self.loadedAll.accept($0.isEmpty)
        }).map({[unowned self] in
            (self.results.value ?? []) + $0
        })
            .bind(to: results)
            .disposed(by: bag)
    }
    func performSearch(query: String, page: Int, pageSize: Int) -> Observable<[WordModel]> {
        return self.apiManager.performSearch(query: query, page: page, pageSize: pageSize)
    }
    
    func cellData(for model: WordModel) -> SearchResultTableViewCellData {
        return SearchResultTableViewCellData(searchText: self.searchText.value, title: model.text, subtitle: model.meanings.map({ meaning in
            meaning.translation.text
        }).joined(separator: ", "), previewURL: model.meanings.first?.previewUrl, showsDisclosureIndicator: model.meanings.count > 1)
    }
    
    func nextController(for model: WordModel) -> ViewControllerProtocol? {
        if model.meanings.count > 1 {
            return Router.shared.meaningsViewController(for: model)
        } else if let meaning = model.meanings.first {
            return Router.shared.detailMeaningViewController(for: meaning)
        }
        return nil
    }
}
