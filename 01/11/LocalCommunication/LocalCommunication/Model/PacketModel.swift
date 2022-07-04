//
//  PacketModel.swift
//  LocalCommunication
//
//  送受信するデータの定義
//


import SwiftUI

class PacketModel: Codable {
    var command : Command
    var userInfo : UserInfoModel

    enum Command: String, Codable {
        case BEACON = "beacon"
        case LINE   = "line"
        case CLEAR  = "clear"
    }
    
    init(command: Command, userInfo: UserInfoModel)
    {
        self.command = command
        self.userInfo = userInfo
    }
}
