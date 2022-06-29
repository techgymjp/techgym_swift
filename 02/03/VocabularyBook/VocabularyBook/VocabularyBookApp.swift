//
//  VocabularyBookApp.swift
//  VocabularyBook
//

import SwiftUI

@main
struct VocabularyBookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
