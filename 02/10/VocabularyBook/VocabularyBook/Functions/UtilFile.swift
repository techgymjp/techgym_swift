//
//  UtilFile.swift
//  VocabularyBook
//
//  ファイル関係のユーティリティ
//

import SwiftUI


class UtileFile {
    // テンポラリフォルダをクリーン
    static func clearTempDirectory() {
        do {
            let tmpUrl = FileManager.default.temporaryDirectory
            let tmpDirectory = try FileManager.default.contentsOfDirectory(atPath: tmpUrl.path)
            try tmpDirectory.forEach {file in
                let fileUrl = tmpUrl.appendingPathComponent(file)
                try FileManager.default.removeItem(atPath: fileUrl.path)
            }
        } catch let error as NSError {
            NSLog(error.localizedDescription)
        }
    }
}
