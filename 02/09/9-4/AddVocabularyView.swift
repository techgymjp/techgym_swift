//
//  AddVocabularyView.swift
//  VocabularyBook
//

import SwiftUI
import CoreData


struct AddVocabularyView: View {
    
    @Environment(\.managedObjectContext) private var viewContext   // core data 取扱用

    @Binding var isOpen: Bool
    
    @State private var strSearch: String = ""
    @State private var strTranslated: String = ""
    @State private var urlImageFile: URL? = nil
    @State private var isLoading: Bool = false
    
    private var language: String
    private var api = APIService()

    init(language: String, isOpen: Binding<Bool>){
        self.language = language
        self._isOpen = isOpen
    }
    
    var body: some View {
        ScrollView {
            TextField("翻訳したい言葉を入力", text: $strSearch)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.webSearch)
                .onSubmit {
                    doTranslate()
                }
                .padding()
            
            //翻訳後の文章＆イメージ
            Text(strTranslated)
                .frame(maxWidth: .infinity)
                .frame(height: UtileSize.decode(100))
                .background(.thinMaterial)
                .cornerRadius(UtileSize.decode(4))
                .padding(.horizontal)
            
            AsyncImage(url: urlImageFile){ image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                if isLoading {
                    ProgressView()
                }else{
                    Image("no_image_square")
                        .resizable()
                        .scaledToFill()
                }
                
            }
            .frame(width: UtileSize.decode(300), height: UtileSize.decode(300))
            .cornerRadius(UtileSize.decode(20))
            
            HStack {
                Button(action: {
                    closeView()
                }) {
                    Text("キャンセル")
                        .fontWeight(.semibold)
                        .frame(width: UtileSize.decode(120) , height: UtileSize.decode(40))
                        .foregroundColor(.white)
                        .background(Color.secondary)
                        .cornerRadius(UtileSize.decode(20))
                        .padding()
                }
                
                Button(action: {
                    addVocabulary()
                    closeView()
                }) {
                    Text("保存")
                        .fontWeight(.semibold)
                        .frame(width: UtileSize.decode(120) , height: UtileSize.decode(40))
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(UtileSize.decode(20))
                        .padding()
                }
            }
        }
    }

    private func doTranslate() {
        if (strSearch == "") { return }
        
        Task {
            isLoading = true
            urlImageFile = nil
            
            guard let resultTrans = await api.translateFromJA(query: strSearch, language: language) else {
                strTranslated = "翻訳できませんでした"
                return
            }
            
            if (0 < resultTrans.data.translations.count) {
                strTranslated = resultTrans.data.translations[0].translatedText
            }
            
            guard let resultImage = await api.searchCustom(query: strTranslated), 0 < resultImage.items.count else {
                return // 画像取得できず
            }
            
            if let tmpURL =  URL(string: resultImage.items[0].image.thumbnailLink) {
                urlImageFile = await api.downloadFile(url: tmpURL)
            }
            
            isLoading = false
        }
    }

    private func addVocabulary() {
        let newVocab = Vocabulary(context: viewContext)
        newVocab.id = UUID()
        newVocab.language = language
        newVocab.jp = strSearch
        newVocab.translated = strTranslated
        
        do {
            let request = NSFetchRequest<Vocabulary>(entityName: "Vocabulary")
            request.includesSubentities = false
            request.predicate = NSPredicate(format: "language == %@", language)
            try newVocab.sequence =  Int64(viewContext.count(for: request) - 1)     //既に自分自身の数が追加されてしまっているので-1
            
            try newVocab.image = urlImageFile != nil ? Data.init(contentsOf: urlImageFile!) : nil
            
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func closeView() {
        strSearch = ""
        strTranslated = ""
        urlImageFile = nil
        isOpen = false
    }
    
}

struct AddVocabularyView_Previews: PreviewProvider {
    static var previews: some View {
        AddVocabularyView(language: "en", isOpen: Binding.constant(true))
    }
}
