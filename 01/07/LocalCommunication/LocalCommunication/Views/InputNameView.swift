//
//  InputNameView.swift
//  LocalCommunication
//

import SwiftUI

struct InputNameView: View {
    @State private var myUserInfo = UserInfoModel(name: "")
    
    var enableButton: Bool {
        return myUserInfo.name != ""
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                Image("network")
                    .resizable()
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
                
                TextField("ニックネーム", text: $myUserInfo.name )
                    .overlay(Divider(), alignment: .bottom)
                    .padding()
                
                NavigationLink(destination: DrawCanvasView()) {
                    Text("スタート")
                        .fontWeight(.semibold)
                        .frame(width: UtileSize.decode(180) , height: UtileSize.decode(40))
                        .foregroundColor( .white )
                        .background( enableButton ? Color.accentColor : Color.secondary )
                        .cornerRadius(UtileSize.decode(20))
                }.disabled(!enableButton)
                
                Spacer()
            }
        }
    }
}

struct InputNameView_Previews: PreviewProvider {
    static var previews: some View {
        InputNameView()
    }
}
