//
//  myWalletApp.swift
//  myWallet
//
//  Created by Marcoulakis ⠀ on 14/05/23.
//

import SwiftUI

@main
struct myWalletApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext
            let dateHolder = DateHolder(context)

            myWalletView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(dateHolder)
        }
    }
}
