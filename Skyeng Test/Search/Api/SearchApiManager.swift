//
//  SearchApiManager.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
import RxSwift
class SearchApiManager: ApiManager {
    func performSearch(query: String, page: Int, pageSize: Int) -> Observable<[WordModel]> {
        self.sendRequest(.get, requestURL(endpoint: "/words/search"), parameters: ["search":query, "page":page, "pageSize":pageSize])
    }
}
