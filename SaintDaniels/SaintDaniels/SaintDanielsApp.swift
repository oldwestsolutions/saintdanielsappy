//
//  SaintDanielsApp.swift
//  SaintDaniels
//
//  Created by user277255 on 3/27/25.
//

import SwiftUI

@main
struct SaintDanielsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
