//
//  SearchApiManager.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
import RxSwift
protocol SearchApiManagerProtocol: class {
    func performSearch(query: String, page: Int, pageSize: Int) -> Observable<[WordModel]?>
    func getDetailMeaning(id: Int) -> Observable<[DetailMeaningModel]?>
}

class SearchApiManager: ApiManager, SearchApiManagerProtocol {
    func performSearch(query: String, page: Int, pageSize: Int) -> Observable<[WordModel]?> {
        self.sendRequest(.get, requestURL(endpoint: "/words/search"), parameters: ["search":query, "page":page, "pageSize":pageSize])
    }
    
    func getDetailMeaning(id: Int) -> Observable<[DetailMeaningModel]?> {
        self.sendRequest(.get, requestURL(endpoint: "/meanings"), parameters: ["ids":id])
    }
}
