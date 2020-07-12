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
    var hint = BehaviorRelay<String?>(value: nil)
    var hintImage = BehaviorRelay<NSTextAttachment?>(value: nil)
    
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
        
        results.compactMap({$0?.isEmpty}).subscribe(onNext: { [unowned self] resultsEmpty in
            if resultsEmpty {
                if self.searchText.value?.isEmpty ?? true {
                    self.hint.accept("EMPTY_SEARCH_HINT".localized)
                    self.hintImage.accept(self.constructAttachment(symbolName: "book"))
                } else {
                    self.hint.accept("EMPTY_RESULTS_HINT".localized)
                    self.hintImage.accept(self.constructAttachment(symbolName: "doc.text.magnifyingglass"))
                }
            } else {
                self.hint.accept(nil)
                self.hintImage.accept(nil)
            }
        }).disposed(by: bag)
    }
    
    func constructAttachment(symbolName: String) -> NSTextAttachment {
        let image = UIImage(systemName: symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)) ?? UIImage()
        let attachment = NSTextAttachment(image: image)
        attachment.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        return attachment
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
