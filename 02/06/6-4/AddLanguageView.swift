//
//  AddLanguageView.swift
//  VocabularyBook
//

import SwiftUI

struct AddLanguageView: View {
    @EnvironmentObject var stateVocabularyBook: VocabularyBookState
    @Environment(\.managedObjectContext) private var viewContext   // core data 取扱用

    var body: some View {
        List{
            Section(header: Text("追加したい言語を選択")) {
                ForEach(stateVocabularyBook.masterLanguages) { (language) in
                    Text(language.text_jp)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .onTapGesture {
                            addLanguage(lang:language)
                        }
                }
            }
        }
        .listStyle(.inset)
    }
    
    private func addLanguage(lang:LanguageModel) {
        let newLang = Language(context: viewContext)
        newLang.language = lang.language
        newLang.text_jp = lang.text_jp
        newLang.sequence = 0 // TODO あとで
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}

struct AddLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        AddLanguageView()
    }
}
