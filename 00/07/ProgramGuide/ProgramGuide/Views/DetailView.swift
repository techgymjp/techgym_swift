//
//  DetailView.swift
//  ProgramGuide
//

import SwiftUI

struct DetailView: View {
    
    @State private var strSearch: String = ""

    private let programModel: ProgramModel

    init(programModel: ProgramModel) {
        self.programModel = programModel
    }
    
    var body: some View {
        VStack(spacing: 5){
            Image(self.programModel.image)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 100)
            Text(self.programModel.description)
            Text(strSearch)
            Spacer()
            TextField("メモ", text: $strSearch)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(programModel:ProgramModels[0])
    }
}
