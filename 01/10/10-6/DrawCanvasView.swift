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
    @State private var users: [UserBeaconModel] = []

    let timer = Timer.publish(every: BEACON_SEC, on: .main, in: .common).autoconnect()
    private var myUserInfo: UserInfoModel
    
    init(myUserInfo: UserInfoModel){
        self.myUserInfo = myUserInfo
    }
    
    var body: some View {
        VStack {
        }
        .onAppear() {
            sendBecon()
        }
        .onReceive(timer) { _ in
            sendBecon()
        }
        .onReceive(udpConnection.recvDataSubject) { data in
            recvData(data)
        }
    }
    
    func sendBecon() {
        do {
            let encoder = JSONEncoder()
            let packet = PacketModel(command: .BECON, userInfo: myUserInfo)
            let data :Data =  try encoder.encode(packet)
            udpConnection.send(payload : data)
        } catch {
            NSLog("error sendBecon")
        }
    }
    
    func recvData(_ data: Data) {
        do{
            let decoder = JSONDecoder()
            let packet: PacketModel = try decoder.decode(PacketModel.self, from: data)
            
            switch packet.command {
            case .BECON :
                // この辺りに仕込めば送受信できていることが確認できるでしょう
                // NSLog(packet.userInfo.name)
                if let user = users.first(where: { $0.userinfo.id == packet.userInfo.id }) {
                    user.counter = BEACON_LIFETIME
                } else {
                    users.append(UserBeaconModel(userinfo: packet.userInfo))
                }
            case .LINE :
                break
            case .CLEAR :
                break
            }
        }catch{
            NSLog("error recvData")
        }
    }
}

struct DrawCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        DrawCanvasView(myUserInfo: UserInfoModel(name: "プレビュー太郎", icon: .robot))
    }
}
