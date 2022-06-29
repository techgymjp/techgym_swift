//
//  UtileSize.swift
//  LocalCommunication
//
//  端末によってスクリーンの大きさが違うことを吸収するためのutility
//  横方向は 375 を基準サイズとし、それぞれの端末の横サイズにスケーリングする
//  縦方向の伸びは端末によって違うことを許容する
//

import SwiftUI


class UtileSize {
    static let STANDARD_WIDTH : CGFloat = 375;    // このサイズを基準とする
    static let scale : CGFloat  = UIScreen.main.bounds.size.width / UtileSize.STANDARD_WIDTH;
    
    static func encode(_ w: CGFloat) -> CGFloat {
        return w / scale;
    }
    
    static func decode(_ w: CGFloat) -> CGFloat {
        return w * scale;
    }
    
    static func encode(_ p: CGPoint) -> CGPoint {
        return CGPoint(x: p.x / scale, y: p.y / scale)
    }
    
    static func decode(_ p: CGPoint) -> CGPoint {
        return CGPoint(x: p.x * scale, y: p.y * scale)
    }
}
