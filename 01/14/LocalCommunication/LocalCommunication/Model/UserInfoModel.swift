//
//  UserInfoModel.swift
//  LocalCommunication
//
//  ユーザー情報のモデル定義
//

import Foundation


struct UserInfoModel: Identifiable, Codable {
    var id = UUID()
    var name: String = ""
    var icon = Icon.alien

    enum Icon: String, CaseIterable, Identifiable, Codable {
        case alien = "👽"
        case invader = "👾"
        case robot = "🤖"
        case ghost = "👻"
        
        var id: String { rawValue }
    }
}

