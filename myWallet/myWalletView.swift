//
//  ContentView.swift
//  myWallet
//
//  Created by Marcoulakis ⠀ on 14/05/23.
//

import SwiftUI
import CoreData

struct myWalletView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder

    @State private var isEditingBalance = false
    @State private var newBalance = ""

    @FetchRequest(entity: Balance.entity(), sortDescriptors: []) var balances: FetchedResults<Balance>

    private var balance: Float {
        if isEditingBalance {
            return Float(newBalance) ?? 0
        } else {
            if let firstBalance = balances.first {
                return Float(firstBalance.value) // Convert Int64 to Float
            } else {
                return 0
            }
        }
    }

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.purchaseDate, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: BalanceView()) {
                    VStack {
                        Text("Balance:")
                            .font(.system(size: 44))
                            .foregroundColor(.primary)
                        Text(String(format: "R$ %.2f", (balance/100)))
                            .font(.system(size: 32))
                            .bold()
                            .foregroundColor(.primary)
                    }
                }

                List {
                    ForEach(items) { item in
                        NavigationLink(destination: InfoView(passedItem: item, initalDate: Date())
                            .environmentObject(dateHolder)) {
                            ItemCell(passedItem: item)
                                .environmentObject(dateHolder)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        NavigationLink(destination: InfoView(passedItem: nil, initalDate: Date())
                            .environmentObject(dateHolder)) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let balanceObj = balances.first ?? Balance(context: viewContext)
            balanceObj.value += Int64(items[0].value * 100)
            do {
                try viewContext.save()
            } catch {
                print("Error saving balance: \(error.localizedDescription)")
            }

            offsets.map { items[$0] }.forEach(viewContext.delete)

            dateHolder.saveContext(viewContext)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        myWalletView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
