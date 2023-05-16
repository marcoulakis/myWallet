//
//  myWalletApp.swift
//  myWallet
//
//  Created by Marcoulakis ⠀ on 14/05/23.
//

import SwiftUI


extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

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
