//
//  CustomSearchModel.swift
//  VocabularyBook
//

import Foundation


struct ResponceCustomSearchModel: Codable {
    var items: [ResponceCustomSearchItemModel]
}

struct ResponceCustomSearchItemModel: Codable {
    var image: ResponceCustomSearchItemImageModel
}

struct ResponceCustomSearchItemImageModel: Codable {
    var thumbnailLink: String
}
