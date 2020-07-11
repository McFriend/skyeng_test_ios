//
//  Router.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation

class Router {
    static var shared: Router = {
        let instance = Router()
        return instance
    }()
    private init() {}

    func mainViewController() -> ViewControllerProtocol {
        return emptyViewController()
    }
    
    func emptyViewController() -> ViewControllerProtocol {
        return ViewController(viewModel: ViewModel())
    }
}
