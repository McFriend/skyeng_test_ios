//
//  Errors.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case noData
    case unexpected(String)
}
