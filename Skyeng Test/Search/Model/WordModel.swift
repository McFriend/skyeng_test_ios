//
//  WordModel.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation
struct WordModel: Decodable {
    let id: Int
    let text: String
    let meanings: [MeaningModel]
}

struct MeaningModel: Decodable {
    struct Translation: Decodable {
        let text: String
        let note: String?
    }
    let id: Int
    let partOfSpeechCode: String
    let translation: Translation
    let previewUrl: String
    let imageUrl: String
    let transcription: String
    let soundUrl: String
}
