//
//  Router.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
class Router {
    static var shared: Router = {
        let instance = Router()
        return instance
    }()
    private init() {}

    func mainViewController() -> ViewControllerProtocol {
        return searchViewController()
    }
    
    func emptyViewController() -> ViewControllerProtocol {
        return ViewController(viewModel: ViewModel())
    }
    
    func searchViewController() -> ViewControllerProtocol {
        let viewModel = SearchViewModel()
        let viewController = SearchViewController(viewModel: viewModel)
        let navigationController = NavigationController(rootViewController: viewController)
        return navigationController
    }
    
    func meaningsViewController(for word: WordModel) -> ViewControllerProtocol {
        let viewModel = SearchResultViewModel(result: BehaviorRelay(value: word))
        let viewController = SearchResultController(viewModel: viewModel)
        return viewController
    }
    
    func detailMeaningViewController(for meaning: MeaningModel) -> ViewControllerProtocol {
        let viewModel = DetailMeaningViewModel(parentModel: meaning)
        let viewController = DetailMeaningController(viewModel: viewModel)
        return viewController
    }
}
