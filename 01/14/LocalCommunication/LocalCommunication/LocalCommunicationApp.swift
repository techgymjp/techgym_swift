//
//  LocalCommunicationApp.swift
//  LocalCommunication
//

import SwiftUI


@main
struct LocalCommunicationApp: App {
    
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background :
                udpConnection.finalize()
            case .active :
                udpConnection.initialise()
            case .inactive :
                break // バックグラウンドorフォアグラウンド直前
            default :
                NSLog("scenePhase default")
                break
            }
        }
    }
    
    init(){
        // ネットワークのコネクションはアプリがバックグラウンドに入ると切れてしまうため
        // アプリがフォアグラウンド、バックグラウンド、になる、トリガを検知し初期化をおこなったが
        // バックグラウンドに入っても何かがリセットされないような初期化であればこのinitに記載するのが良い
    }
}
