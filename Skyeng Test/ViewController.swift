//
//  ViewController.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit
protocol ViewControllerProtocol: UIViewController {}

class ViewController: UIViewController, ViewControllerProtocol {
    var _viewModel: ViewModelProtocol?
    init(viewModel: ViewModelProtocol?) {
        self._viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustUI()
        configureConstraints()
        bind()
    }
    
    ///Добавление элементов UI на экран. Настройка внешнего вида.
    open func adjustUI() {
        view.backgroundColor = view.backgroundColor ?? UIColor.systemBackground
    }
    
    ///Биндинг UI и ViewModel
    open func bind() {
        
    }
    
    ///Расположение элементов на экране.
    open func configureConstraints() {

    }
}

