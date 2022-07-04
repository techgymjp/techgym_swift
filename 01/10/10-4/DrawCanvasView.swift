//
//  DrawCanvasView.swift
//  LocalCommunication
//

import SwiftUI


private let BEACON_SEC : TimeInterval = 3   // ビーコン送信間隔、秒
private let BEACON_LIFETIME : Int = 3       // ビーコンのロスト許容回数

private class UserBeaconModel {
    var userinfo : UserInfoModel
    var counter : Int
    
    init(userinfo : UserInfoModel)
    {
        self.userinfo = userinfo
        counter = BEACON_LIFETIME
    }
}

struct DrawCanvasView: View {
    
    let timer = Timer.publish(every: BEACON_SEC, on: .main, in: .common).autoconnect()
    private var myUserInfo: UserInfoModel
    
    init(myUserInfo: UserInfoModel){
        self.myUserInfo = myUserInfo
    }
    
    var body: some View {
        VStack {
        }
        .onAppear() {
            sendBeacon()
        }
        .onReceive(timer) { _ in
            sendBeacon()
        }
    }
    
    func sendBeacon() {
        do {
            let encoder = JSONEncoder()
            let packet = PacketModel(command: .BEACON, userInfo: myUserInfo)
            let data :Data =  try encoder.encode(packet)
            udpConnection.send(payload : data)
        } catch {
            NSLog("error sendBeacon")
        }
    }
}

struct DrawCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        DrawCanvasView(myUserInfo: UserInfoModel(name: "プレビュー太郎", icon: .robot))
    }
}
