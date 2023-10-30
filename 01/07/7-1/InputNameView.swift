//
//  InputNameView.swift
//  LocalCommunication
//

import SwiftUI

struct InputNameView: View {
    @State private var myUserInfo = UserInfoModel(name: "")

    var body: some View {
        NavigationStack {
            NavigationLink(destination: DrawCanvasView()) {
                Text("スタート")
                    .fontWeight(.semibold)
            }
        }
    }
}

struct InputNameView_Previews: PreviewProvider {
    static var previews: some View {
        InputNameView()
    }
}
