//
//  SearchResultViewModel.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SearchResultViewModel: ViewModel {
    var result: Observable<WordModel>
    
    init(result: Observable<WordModel>) {
        self.result = result
        super.init()
    }

    
    func cellData(for model: MeaningModel) -> SearchResultTableViewCellViewModel {
        return SearchResultTableViewCellViewModel(searchText: nil, title: model.translation.text, subtitle: model.translation.note, previewURL: model.previewUrl, showsDisclosureIndicator: false)
    }

}
