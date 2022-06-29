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
    
    @State private var isShowDeleteAlert = false
    @State private var deleteIndex: Int? = nil
    
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
        .confirmationDialog("", isPresented: $isShowDeleteAlert){
            Button("削除する", role: .destructive, action: deleteLanguage)
            Button("キャンセル", role: .cancel, action: {/*do nothing*/})
        } message: {
            Text("本当に削除しますか？")
        }
    }
    
    private func willDeleteLanguages(offsets: IndexSet) {
        isShowDeleteAlert = true
        deleteIndex = offsets.min()
    }
    
    private func deleteLanguage() {
        guard let _deleteIndex = deleteIndex else { return }
        withAnimation {
            (_deleteIndex..<languages.count).forEach { idx in
                languages[idx].sequence = languages[idx].sequence - 1
            }
            
            viewContext.delete(languages[_deleteIndex])
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func moveLanguage(offsets: IndexSet, index:Int) {
        
        guard let nowIdx = offsets.min() else { return }
        
        if nowIdx == index { return }
        
        if( nowIdx < index ){
            languages[nowIdx].sequence = Int64(index)
            (nowIdx..<index).forEach { idx in
                languages[idx].sequence = languages[idx].sequence - 1
            }
        }else{
            languages[nowIdx].sequence = Int64(index)
            (index..<nowIdx).forEach { idx in
                languages[idx].sequence = languages[idx].sequence + 1
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct LanguagesView_Previews: PreviewProvider {
    static var previews: some View {
        LanguagesView()
    }
}
