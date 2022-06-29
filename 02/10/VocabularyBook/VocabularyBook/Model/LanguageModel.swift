//
//  LanguageModel.swift
//  VocabularyBook
//

import Foundation


struct LanguageModel: Codable, Identifiable {
    var id: String
    var language:String {
        return self.id
    }
    var text_jp: String
    
    enum CodingKeys: String, CodingKey {
        case id         = "language"
        case text_jp    = "text_jp"
    }
}
