//
//  ViewModel.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
import RxSwift
protocol DisposeBagContainer {
    var bag: DisposeBag {get set}
}
protocol ViewModelProtocol: DisposeBagContainer {
    func configure()
}

class ViewModel: ViewModelProtocol {
    var bag: DisposeBag = DisposeBag()
    
    init() {
        configure()
    }
    
    open func configure() {
        
    }
}
