//
//  AddLanguageView.swift
//  VocabularyBook
//

import SwiftUI

struct AddLanguageView: View {
    @EnvironmentObject var stateVocabularyBook: VocabularyBookState
    
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
    }
}

struct AddLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        AddLanguageView()
    }
}
