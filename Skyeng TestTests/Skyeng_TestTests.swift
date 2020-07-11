//
//  Skyeng_TestTests.swift
//  Skyeng TestTests
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import XCTest
import RxSwift
import RxRelay
import RxBlocking
@testable import Skyeng_Test
fileprivate class MockSearchApiManagerEmptyResult : SearchApiManagerProtocol {
    func performSearch(query: String, page: Int, pageSize: Int) -> Observable<[WordModel]> {
        return .just([])
    }
    func getDetailMeaning(id: Int) -> Observable<[DetailMeaningModel]> {
        return .just([])
    }

}

class SearchViewModelTests: XCTestCase {
    var viewModel : SearchViewModel!
    fileprivate var apiManager : SearchApiManagerProtocol!
    fileprivate var bag = DisposeBag()
    override func setUp() {
        super.setUp()
        self.apiManager = SearchApiManager()
        self.viewModel = SearchViewModel(apiManager: apiManager)
    }

    override func tearDown() {
        self.viewModel = nil
        self.apiManager = nil
        bag = DisposeBag()
        super.tearDown()
    }
        
    func testSearchEmptyResult() {
        // giving no service to a view model
        viewModel.apiManager = MockSearchApiManagerEmptyResult()

        XCTAssert(try viewModel.performSearch(query: "Test", page: 1, pageSize: 10).toBlocking(timeout: 10).first()?.isEmpty == true, "Response should be empty.")
    }
    
    func testSearchEmptyQuery() {
        // giving no service to a view model
        viewModel.apiManager = SearchApiManager()

        // expected to not be able to fetch currencies
        XCTAssert(try viewModel.performSearch(query: "", page: 1, pageSize: 10).toBlocking(timeout: 10).first()?.isEmpty == true, "Response should be empty.")
    }
    
    func testSearchDefaultQuery() {
        // giving no service to a view model
        viewModel.apiManager = SearchApiManager()

        // expected to not be able to fetch currencies
        XCTAssert(try self.viewModel.performSearch(query: "Test", page: 1, pageSize: 10).toBlocking(timeout: 10).first()?.isEmpty == false, "Response should be empty.")
    }

}
