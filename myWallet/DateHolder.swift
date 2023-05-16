//
//  DateHolder.swift
//  myWallet
//
//  Created by Marcoulakis ⠀ on 14/05/23.
//

import SwiftUI
import CoreData

class DateHolder: ObservableObject{
    
    init(_ context: NSManagedObjectContext){
        
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
