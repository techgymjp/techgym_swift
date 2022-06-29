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
    var drawLine : DrawLineModel?

    enum Command: String, Codable {
        case BECON  = "becon"
        case LINE   = "line"
        case CLEAR  = "clear"
    }
    
    init(command: Command, userInfo: UserInfoModel, drawLine: DrawLineModel? = nil)
    {
        self.command = command
        self.userInfo = userInfo
        self.drawLine = drawLine
    }
}
