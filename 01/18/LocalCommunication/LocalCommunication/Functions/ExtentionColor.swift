//
//  ExtentionColor.swift
//  LocalCommunication
//

import SwiftUI


extension Color {
    func toFloatRGBA() -> (r:Float, g:Float, b:Float, a:Float) {
        guard let components = self.cgColor?.components, 4 <= components.count else {
            return (r:0, g:0, b:0, a:0)
        }
        
        return (r:Float(components[0]), g:Float(components[1]), b:Float(components[2]), a:Float(components[3]))
    }
}
