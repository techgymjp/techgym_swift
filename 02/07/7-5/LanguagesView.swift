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
    
    @State private var isShowAddLanguageView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(languages) { language in
                    NavigationLink(destination: VocabulariesView()) {
                        Text(language.text_jp ?? "")
                    }
                }
                .onMove(perform: moveLanguage)
                .onDelete(perform: willDeleteLanguages)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing)  {
                    Button(action: { isShowAddLanguageView = true } ) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isShowAddLanguageView){
            AddLanguageView(isOpen: $isShowAddLanguageView)
        }
    }
    
    private func willDeleteLanguages(offsets: IndexSet) {
    }
    
    private func deleteLanguage() {
    }
    
    private func moveLanguage(offsets: IndexSet, index:Int) {
    }
}

struct LanguagesView_Previews: PreviewProvider {
    static var previews: some View {
        LanguagesView()
    }
}
