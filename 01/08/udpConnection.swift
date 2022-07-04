//
//  udpConnection.swift
//  LocalCommunication
//

import Foundation
import Network
import Combine


class udpConnection
{
    static private let HOST: NWEndpoint.Host = "255.255.255.255"
    static private let PORT: NWEndpoint.Port = 50000
    
    static private var sendConnection: NWConnection?
    static private var sendConnectionMyself: NWConnection?
    static private var recvListener: NWListener?
    
    // static public let recvStringSubject = PassthroughSubject<String, Never>()
    static public let recvDataSubject = PassthroughSubject<Data, Never>()
    
    static func initialise()
    {
        initialiseSend()
        initialiseRecive()
    }
    static func finalize()
    {
        finalizeSend()
        finalizeRecive()
    }
    
    //MARK: - send
    static private func initialiseSend()
    {
        finalizeSend()
        sendConnection = NWConnection(host: HOST, port: PORT, using: .udp)
        
        // このコールバックはこの教材においてはなくても良い。しかし、エラー処理などをきちんと対応しなければいけない場合にはいろいろ対応する必要がある。
        // 参考のためのソースとして記載しておく
        sendConnection!.stateUpdateHandler = { state in
            switch (state) {
            case .preparing:
                NSLog("sendconnection state: preparing")
            case .ready:
                NSLog("sendconnection state: ready")
            case .setup:
                NSLog("sendconnection state: setup")
            case .cancelled:
                NSLog("sendconnection state: cancelled")
            case .waiting:
                NSLog("sendconnection state: waiting")
            case .failed:
                NSLog("sendconnection state: failed")
            @unknown default:
                NSLog("sendconnection state: unknown")
                fatalError()
            }
        }
        
        sendConnection!.start(queue: DispatchQueue.global())
        
        
#if targetEnvironment(simulator)
#else
        // 実機だと"255.255.255.255"のbroadcastで自分自身に到達しない。NWConnectionが何かおかしい気がするのだが・・・？
        sendConnectionMyself = NWConnection(host: "127.0.0.1", port: PORT, using: .udp)
        sendConnectionMyself!.start(queue: DispatchQueue.global())
#endif
    }
    
    static private func finalizeSend()
    {
        sendConnection?.forceCancel()
        sendConnection = nil
        
        sendConnectionMyself?.forceCancel()
        sendConnectionMyself = nil
    }
    
    static func send(payload: Data)
    {
        guard let connection = sendConnection else { NSLog("udpConnection not initialised!"); return }
        
        connection.send(content: payload, completion: .contentProcessed({ sendError in
            if let error = sendError {
                NSLog("send error: \(error)")
            }
        }))
        
        sendConnectionMyself?.send(content: payload, completion: .contentProcessed({ sendError in
            if let error = sendError {
                NSLog("send error: \(error)")
            }
        }))
    }
    
    //MARK: - recive
    static private func initialiseRecive()
    {
        finalizeRecive()
        recvListener = try! NWListener(using: NWParameters.udp, on: PORT)
        
        if let listener = recvListener {
            
            listener.newConnectionHandler = { connection in
                connection.receiveMessage(completion: {(data, context, isComplete, error) in
                    if let _error = error {
                        NSLog("recvconnection error", _error.localizedDescription)
                    }
                    
                    if let _data = data {
                        DispatchQueue.main.async {
                            recvDataSubject.send(_data)
                        }
                    }
                    
                    if isComplete  {
                        connection.cancel()
                    }
                })
                
                connection.start(queue: DispatchQueue.global())
            }
            
            // このコールバックはこの教材においてはなくても良い。しかし、エラー処理などをきちんと対応しなければいけない場合にはいろいろ対応する必要がある。
            // 参考のためのソースとして記載しておく
            listener.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    NSLog("recvlistener state: ready")
                case .waiting(_):
                    NSLog("recvlistener state: waiting")
                case .failed(_):
                    NSLog("recvlistener state: failed")
                case .setup:
                    NSLog("recvlistener state: setup")
                case .cancelled:
                    NSLog("recvlistener state: cancelled")
                @unknown default:
                    NSLog("recvlistener state: unknown")
                    fatalError()
                }
            }
            
            listener.start(queue: DispatchQueue.global())
        }
        else
        {
            NSLog("recive listen error!!")
        }
    }
    
    static private func finalizeRecive()
    {
        recvListener?.cancel()
        recvListener = nil
    }
}
