//
//  AddVocabularyView.swift
//  VocabularyBook
//

import SwiftUI

struct AddVocabularyView: View {
    
    @Binding var isOpen: Bool
    
    @State private var strSearch: String = ""
    @State private var strTranslated: String = ""
    @State private var urlImageFile: URL? = nil
    @State private var isLoading: Bool = false
    
    private var language: String
    
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
