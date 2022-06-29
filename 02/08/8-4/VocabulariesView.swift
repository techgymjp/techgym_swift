//
//  VocabulariesView.swift
//  VocabularyBook
//

import SwiftUI

struct VocabulariesView: View {
    
    @State private var isShowAddVocabularyView = false
    
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
        .toolbar {
            Button(action: {
                isShowAddVocabularyView = true
            }) {
                Label("Add Item", systemImage: "plus")
            }
            .disabled(isShowAddVocabularyView)
        }
        .fullScreenCover(isPresented: $isShowAddVocabularyView) {
            AddVocabularyView(language: language, isOpen: $isShowAddVocabularyView)
        }
    }
}

struct VocabulariesView_Previews: PreviewProvider {
    static var previews: some View {
        VocabulariesView(language: "en")
    }
}
