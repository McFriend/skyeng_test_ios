//
//  DetailMeaningModel.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import Foundation

struct DetailMeaningModel: Decodable {
    enum PartOfSpeech: String, Decodable {
        case noun = "n"
        case verb = "v"
        case adjective = "j"
        case adverb = "r"
        case preposition = "prp"
        case pronoun = "prn"
        case cardinalNumber = "crd"
        case conjunction = "cjc"
        case interjection = "exc"
        case article = "det"
        case abbreviation = "abb"
        case particle = "x"
        case ordinalNumber = "ord"
        case modalVerb = "md"
        case phrase = "ph"
        case idiom = "phi"

        var localizedValue: String {
            switch self {
            case .noun:
                return "NOUN".localized
            case .verb:
                return "VERB".localized
            case .adjective:
                return "ADJECTIVE".localized
            case .adverb:
                return "ADVERB".localized
            case .preposition:
                return "PREPOSITION".localized
            case .pronoun:
                return "PRONOUN".localized
            case .cardinalNumber:
                return "CARDINAL_NUMBER".localized
            case .conjunction:
                return "CONJUNCTION".localized
            case .interjection:
                return "INTERJECTION".localized
            case .article:
                return "ARTICLE".localized
            case .abbreviation:
                return "ABBREVIATION".localized
            case .particle:
                return "PARTICLE".localized
            case .ordinalNumber:
                return "ORDINAL_NUMBER".localized
            case .modalVerb:
                return "MODAL_VERB".localized
            case .phrase:
                return "PHRASE".localized
            case .idiom:
                return "IDIOM".localized
            }
        }
    }
    struct Definition: Decodable {
        let text: String
        let soundUrl: String
    }
    struct Image: Decodable {
        let url: String
    }
    let id: String
    let wordId: Int
    let difficultyLevel: Int?
    let partOfSpeechCode: PartOfSpeech?
    let prefix: String?
    let text: String?
    let soundUrl: String?
    let transcription: String?
    let mnemonics: String?
    let translation: MeaningModel.Translation?
    let definition: Definition?
    let examples: [Definition]?
    let images: [Image]?
}
