//
//  AddVocabularyView.swift
//  VocabularyBook
//

import SwiftUI

struct AddVocabularyView: View {

    @Binding var isOpen: Bool

    private var language: String

    init(language: String, isOpen: Binding<Bool>){
        self.language = language
        self._isOpen = isOpen
    }

    var body: some View {
        Text("AddVocabularyView")
    }
}

struct AddVocabularyView_Previews: PreviewProvider {
    static var previews: some View {
        AddVocabularyView(language: "en", isOpen: Binding.constant(true))
    }
}
