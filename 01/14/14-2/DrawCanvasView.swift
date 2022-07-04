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

    @State private var lines: [DrawLineModel] = []    // ライン

    let timer = Timer.publish(every: BEACON_SEC, on: .main, in: .common).autoconnect()
    private var myUserInfo: UserInfoModel
    
    init(myUserInfo: UserInfoModel){
        self.myUserInfo = myUserInfo
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(users .map({$0.userinfo})) { user in
                        Text( user.icon.rawValue + " " + user.name)
                            .font(.system(size: 15))
                            .frame(height: UtileSize.decode(30))
                            .padding(UtileSize.decode(2))
                            .background(.white)
                            .cornerRadius(UtileSize.decode(5))
                    }
                }.padding(.horizontal)
            }
            .frame(height: UtileSize.decode(48))
            .background(.gray)
            .padding()
        }
        .onAppear() {
            sendBeacon()
        }
        .onReceive(timer) { _ in
            refreshUsers()
            sendBeacon()
        }
        .onReceive(udpConnection.recvDataSubject) { data in
            recvData(data)
        }
        .navigationBarTitleDisplayMode(.inline)
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
    
    func sendLine(_ lineModel:DrawLineModel)  {
        do {
            let encoder = JSONEncoder()
            let packet = PacketModel(command: .LINE, userInfo: myUserInfo, drawLine: lineModel)
            let data :Data =  try encoder.encode(packet)
            udpConnection.send(payload : data)
        } catch {
            NSLog("error sendLine")
        }
    }

    func recvData(_ data: Data) {
        do{
            let decoder = JSONDecoder()
            let packet: PacketModel = try decoder.decode(PacketModel.self, from: data)
            
            switch packet.command {
            case .BEACON :
                if let user = users.first(where: { $0.userinfo.id == packet.userInfo.id }) {
                    user.counter = BEACON_LIFETIME
                } else {
                    users.append(UserBeaconModel(userinfo: packet.userInfo))
                }
            case .LINE :
                if let lineModel = packet.drawLine {
                    lines.append(lineModel)
                }
            case .CLEAR :
                break
            }
        }catch{
            NSLog("error recvData")
        }
    }
    
    func refreshUsers() {
        users.forEach({ $0.counter -= 1})
        users = users.filter({ 0 < $0.counter })
    }
    
}

struct DrawCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        DrawCanvasView(myUserInfo: UserInfoModel(name: "プレビュー太郎", icon: .robot))
    }
}
