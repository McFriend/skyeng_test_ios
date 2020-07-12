//
//  ApiManager.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire
protocol ApiManagerProtocol {
    
}

class ApiManager: ApiManagerProtocol {
    let baseURL = "https://dictionary.skyeng.ru/api/public/v1"
    func requestURL(endpoint: String) -> String {
        return baseURL + endpoint
    }
    
    func sendRequest<ResultType: Decodable>(_ method: HTTPMethod,
                                            _ url: URLConvertible,
                                            parameters: Parameters? = nil,
                                            encoding: ParameterEncoding = URLEncoding.default,
                                            headers: HTTPHeaders? = nil,
                                            interceptor: RequestInterceptor? = nil) -> Observable<ResultType?> {
        RxAlamofire.requestData(method, url, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor).catchErrorJustReturn((HTTPURLResponse(), Data()))
            .map({ response, data -> ResultType in
                let decoder = JSONDecoder()
                let responseValue = try decoder.decode(ResultType.self, from: data)
                return responseValue
            }).catchErrorJustReturn(nil)
    }
}
