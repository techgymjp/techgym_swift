//
//  InputNameView.swift
//  LocalCommunication
//

import SwiftUI

struct InputNameView: View {
    @State private var myUserInfo = UserInfoModel(name: "")
    
    var body: some View {
        NavigationStack {
            VStack() {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UtileSize.decode(160), height: UtileSize.decode(160))
                    .clipShape(Circle())
                    .overlay (
                        Circle().stroke(Color.blue, lineWidth: 5)
                    )
                
                Picker("Icon", selection: $myUserInfo.icon) {
                    ForEach(UserInfoModel.Icon.allCases) { (icon) in
                        Text(icon.rawValue).tag(icon)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                NavigationLink(destination: DrawCanvasView()) {
                    Text("スタート")
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

struct InputNameView_Previews: PreviewProvider {
    static var previews: some View {
        InputNameView()
    }
}
