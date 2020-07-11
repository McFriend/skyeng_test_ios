//
//  DetailMeaningViewModel.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class DetailMeaningViewModel: ViewModel {
    var model = BehaviorRelay<DetailMeaningModel?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    let parentModel: MeaningModel
    init(parentModel: MeaningModel) {
        self.parentModel = parentModel
        super.init()
        loadDetailModel()
    }
    
    func loadDetailModel() {
        isLoading.accept(true)
        SearchApiManager().getDetailMeaning(id: parentModel.id).do(onNext: { [weak self] _ in
            self?.isLoading.accept(false)
            }, onError: {  [weak self] _ in
            self?.isLoading.accept(false)
        }).compactMap({$0.first}).bind(to: model).disposed(by: bag)
    }
}
