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
    
    let columns: [GridItem] = [
        GridItem(.fixed(UtileSize.decode(185)), spacing: UtileSize.decode(5)),
        GridItem(.fixed(UtileSize.decode(185)), spacing: 0)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: UtileSize.decode(5)) {
                ForEach(vocabularies.wrappedValue) { vocab in
                    VStack(spacing: 0) {
                        
                        Text(vocab.jp ?? "")
                            .font(.system(size: 20))
                            .minimumScaleFactor(0.0001)
                            .lineLimit(5)
                            .frame(height: UtileSize.decode(60))
                            .padding(.horizontal)
                        
                        ZStack(alignment: .bottom) {
                            
                            if let dat = vocab.image, let img = UIImage.init(data: dat) {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UtileSize.decode(180), height: UtileSize.decode(140))
                                    .clipped()
                            }else{
                                Image("no_image_square")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UtileSize.decode(180), height: UtileSize.decode(140))
                                    .clipped()
                            }
                            
                            HStack{
                                Button(action: {
                                }) {
                                    Image(systemName: "speaker")
                                }
                                .frame(width: UtileSize.decode(30), height: UtileSize.decode(30))
                                .background(.white)
                                .clipShape(Circle())
                                
                                Spacer()
                                
                                Button(action: {
                                }) {
                                    Image(systemName: "trash")
                                }
                                .frame(width: UtileSize.decode(30), height: UtileSize.decode(30))
                                .background(.white)
                                .clipShape(Circle())
                            }
                            .padding()
                        }
                        
                        Text(vocab.translated ?? "")
                            .font(.system(size: 20))
                            .minimumScaleFactor(0.0001)
                            .lineLimit(5)
                            .frame(height: UtileSize.decode(60))
                            .padding(.horizontal)
                    }
                    .background(Color.white)
                    .frame(width: UtileSize.decode(185), height: UtileSize.decode(140 + 60 + 60))
                    .cornerRadius(UtileSize.decode(10))
                    .overlay(
                        RoundedRectangle(cornerRadius: UtileSize.decode(10)).stroke(Color.gray, lineWidth: 1)
                    )
                }
            }
        }
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
