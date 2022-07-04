//
//  DrawCanvasView.swift
//  LocalCommunication
//

import SwiftUI


private let BEACON_SEC : TimeInterval = 3   // ビーコン送信間隔、秒
private let BEACON_LIFETIME : Int = 3       // ビーコンのロスト許容回数

private let SEND_POINT_NUM : Int = 10       // この数座標が貯まれば送信

private let MIN_LINE_WIDTH : Double = 1     // 線太さ
private let MAX_LINE_WIDTH : Double = 10    // 線太さ

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
    @State private var currentLine: DrawLineModel?    // いま描画中のライン
    @State private var currentLineColor = Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    @State private var currentLineWidth : Double = MIN_LINE_WIDTH
    
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
            
            ZStack {
                // Canvas部分
                Rectangle()
                    .fill(Color.white)
                    .border(Color.black, width: 1)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ value in
                                if currentLine == nil {
                                    currentLine = DrawLineModel(color: currentLineColor, width: currentLineWidth)
                                }
                                currentLine!.points.append(UtileSize.encode(value.location))
                                
                                if( SEND_POINT_NUM <= currentLine!.points.count ){
                                    sendLine(currentLine!)
                                    currentLine = DrawLineModel(color: currentLineColor, width: currentLineWidth)
                                    currentLine!.points.append(UtileSize.encode(value.location))
                                }
                            })
                            .onEnded({ value in
                                guard let line = currentLine else { return }
                                
                                line.points.append(UtileSize.encode(value.location))
                                sendLine(line)
                                currentLine = nil
                            })
                    )
                // Lineの描画
                ForEach(lines) { line in
                    Path { path in
                        path.addLines(line.points.map({ UtileSize.decode($0) }))
                    }
                    .stroke( Color(red: Double(line.colorR), green: Double(line.colorG), blue: Double(line.colorB), opacity: Double(line.colorA)) , lineWidth: line.width)
                }
                .clipped()
                
                // 書いている途中のLineの描画
                Path { path in
                    guard let line = currentLine else { return }
                    path.addLines(line.points.map({ UtileSize.decode($0) }))
                }
                .stroke(currentLineColor, lineWidth: UtileSize.decode(currentLineWidth))
                .clipped()
                
            }.padding([.leading, .trailing, .bottom])
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

    func sendClear() {
        do {
            let encoder = JSONEncoder()
            let packet = PacketModel(command: .CLEAR, userInfo: myUserInfo)
            let data :Data =  try encoder.encode(packet)
            udpConnection.send(payload : data)
        } catch {
            NSLog("error sendClear")
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
                lines = []
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
