//
//  VocabularyBookState.swift
//  VocabularyBook
//

import Foundation


class VocabularyBookState: ObservableObject {
    @Published var masterLanguages: [LanguageModel] = UtilBundle.loadJson("Languages.json")
}
