//
//  VocabulariesView.swift
//  VocabularyBook
//

import SwiftUI

struct VocabulariesView: View {

    private let language: String

    init(language: String) {
        self.language = language
    }
    
    var body: some View {
        Text("VocabulariesView")
    }
}

struct VocabulariesView_Previews: PreviewProvider {
    static var previews: some View {
        VocabulariesView(language: "en")
    }
}
