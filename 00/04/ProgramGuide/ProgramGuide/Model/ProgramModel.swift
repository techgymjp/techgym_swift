//
//  ProgramModel.swift
//  ProgramGuide
//

import Foundation

struct ProgramModel: Identifiable{
    var id: String
    var image: String
    var description: String
}


let ProgramModels :[ProgramModel] = [
    ProgramModel(
        id: "Python",
        image: "python",
        description: "Python（パイソン）はインタープリタ型の高水準汎用プログラミング言語である。"
    ),
    ProgramModel(
        id: "Ruby",
        image: "ruby",
        description: "Ruby（ルビー）は、まつもとゆきひろ（通称: Matz）により開発されたオブジェクト指向スクリプト言語（スクリプト言語とはプログラミング言語の一分類）。"
    ),
    ProgramModel(
        id: "Swift",
        image: "swift",
        description: "Swift（スウィフト）は、AppleのiOSおよびmacOS、Linux、Windowsで利用出来るプログラミング言語である。"
    )
]
