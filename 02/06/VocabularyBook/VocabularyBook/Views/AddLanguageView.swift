//
//  AddLanguageView.swift
//  VocabularyBook
//

import SwiftUI

struct AddLanguageView: View {
    @EnvironmentObject var stateVocabularyBook: VocabularyBookState
    @Environment(\.managedObjectContext) private var viewContext   // core data 取扱用
    
    // core data の languages
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Language.language, ascending: true)])
    private var languages: FetchedResults<Language>
    
    var body: some View {
        List{
            Section(header: Text("追加したい言語を選択")) {
                ForEach(filterSavedLanguages()) { (language) in
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
    
    private func filterSavedLanguages() -> [LanguageModel]  {
        return stateVocabularyBook.masterLanguages.filter { master in
            return !languages.contains { saved in
                return saved.language ==  master.language
            }
        }
    }

    private func addLanguage(lang:LanguageModel) {
        let newLang = Language(context: viewContext)
        newLang.language = lang.language
        newLang.text_jp = lang.text_jp
        newLang.sequence = Int64(languages.count)
        
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
