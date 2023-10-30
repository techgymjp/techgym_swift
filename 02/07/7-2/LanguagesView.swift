//
//  LanguagesView.swift
//  VocabularyBook
//

import SwiftUI


struct LanguagesView: View {
    @Environment(\.managedObjectContext) private var viewContext   // core data 取扱用
    // core data の Language
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Language.sequence, ascending: true)])
    private var languages: FetchedResults<Language>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(languages) { language in
                    NavigationLink(destination: VocabulariesView()) {
                        Text(language.text_jp ?? "")
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct LanguagesView_Previews: PreviewProvider {
    static var previews: some View {
        LanguagesView()
    }
}
