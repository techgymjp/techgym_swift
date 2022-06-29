//
//  DrawLineModel.swift
//  LocalCommunication
//
//  描画する線データの定義
//

import SwiftUI


class DrawLineModel: Identifiable, Codable {
    var id = UUID()
    var points: [CGPoint] = []

    var colorR: Float
    var colorG: Float
    var colorB: Float
    var colorA: Float

    var width: Double
    
    init(color: Color, width: Double) {
        let rgb = color.toFloatRGBA()
        self.colorR = rgb.r
        self.colorG = rgb.g
        self.colorB = rgb.b
        self.colorA = rgb.a

        self.width = width
    }
}
