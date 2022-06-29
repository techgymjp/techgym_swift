//
//  TranslateModel.swift
//  VocabularyBook
//

import Foundation


struct RequestTranslateModel: Codable {
    var q: String
    var source: String
    var target: String
    var format: String = "text"
}


struct ResponceTranslateModel: Codable {
    var data: ResponceTranslationsModel
}
struct ResponceTranslationsModel: Codable {
    var translations: [ResponceTranslatedTextModel]
}
struct ResponceTranslatedTextModel: Codable {
    var translatedText: String
}
