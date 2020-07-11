//
//  ViewModel.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
import RxSwift
protocol ViewModelProtocol: ViewModel {
    var bag: DisposeBag {get set}
}
class ViewModel: ViewModelProtocol {
    var bag: DisposeBag = DisposeBag()
    
    init() {
        configure()
    }
    
    open func configure() {
        
    }
}
