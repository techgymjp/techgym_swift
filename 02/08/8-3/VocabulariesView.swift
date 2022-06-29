//
//  VocabulariesView.swift
//  VocabularyBook
//

import SwiftUI

struct VocabulariesView: View {

    private let language: String
    private let vocabularies: FetchRequest<Vocabulary>
    
    init(language: String) {
        self.language = language
        
        vocabularies = FetchRequest<Vocabulary>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Vocabulary.sequence, ascending: true)],
            predicate: NSPredicate(format: "language == %@", language),
            animation: .default
        )
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
