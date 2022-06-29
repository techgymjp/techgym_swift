//
//  VocabulariesView.swift
//  VocabularyBook
//

import SwiftUI
import AVFoundation


struct VocabulariesView: View {
    static let synthesizer = AVSpeechSynthesizer()

    @Environment(\.managedObjectContext) private var viewContext   // core data 取扱用

    @State private var dragging: Vocabulary?
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
                                    speak(vocab:vocab)
                                }) {
                                    Image(systemName: "speaker")
                                }
                                .frame(width: UtileSize.decode(30), height: UtileSize.decode(30))
                                .background(.white)
                                .clipShape(Circle())
                                
                                Spacer()
                                
                                Button(action: {
                                    deleteVocabrary(vocab:vocab)
                                }) {
                                    Image(systemName: "trash")
                                }
                                .frame(width: UtileSize.decode(30), height: UtileSize.decode(30))
                                .background(.white)
                                .clipShape(Circle())
                            }
                            .padding()
                        }
                        
                        Text(vocab.transrated ?? "")
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
                    .onDrag {
                        self.dragging = vocab
                        return NSItemProvider(object: "\(vocab.id!)" as NSString)
                    }
                    .onDrop(of: [UTType.text], delegate: DropViewDelegate(
                        dstItem: vocab,
                        callbackDropEntered: cbDropEntered,
                        callbackPerformDrop: cbPerformDrop) )
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
    
    private func cbDropEntered(dstItem: Vocabulary) {
        let allItems = vocabularies.wrappedValue
        guard let _dragging = dragging else { return }
        
        guard let dragIndex = allItems.firstIndex( where: { $0.id == _dragging.id } ) else { return }
        guard let dropIndex = allItems.firstIndex( where: { $0.id == dstItem.id } ) else { return }
        
        if dragIndex == dropIndex { return }
        
        allItems[dragIndex].sequence = Int64(dropIndex)
        allItems[dropIndex].sequence = Int64(dragIndex)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func cbPerformDrop() {
        dragging = nil
    }
    
    private func deleteVocabrary(vocab:Vocabulary) {
        withAnimation {
            viewContext.delete(vocab)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func speak(vocab:Vocabulary) {
        let speech = AVSpeechUtterance(string: vocab.transrated ?? "")  // 言葉の設定
        speech.voice = AVSpeechSynthesisVoice(language: vocab.language) // 言語の設定
        VocabulariesView.synthesizer.speak(speech)
    }
}

struct DropViewDelegate: DropDelegate {
    var dstItem: Vocabulary
    
    let callbackDropEntered:(Vocabulary)->()
    let callbackPerformDrop:()->()
    
    func dropEntered(info: DropInfo) {
        callbackDropEntered(dstItem)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        callbackPerformDrop()
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}


struct VocabulariesView_Previews: PreviewProvider {
    static var previews: some View {
        VocabulariesView(language: "en")
    }
}
