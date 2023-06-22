//
//  balanceView.swift
//  myWallet
//
//  Created by Marcoulakis on 14/05/23.
//

import SwiftUI

struct BalanceView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder

    @FetchRequest(entity: Balance.entity(), sortDescriptors: []) var balances: FetchedResults<Balance>

    @State private var isEditingBalance = false
    @State private var newBalance = ""

    var body: some View {
        Form {
            Section(header: Text("Bank account")) {
                HStack {
                    Text("Balance")
                    Spacer()
                    if isEditingBalance {
                        TextField("New Balance", text: $newBalance)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .environment(\.layoutDirection, .rightToLeft)
                    } else {
                        Text("R$ \(balance, specifier: "%.2f")")
                    }
                }

                Button(action: {
                    let isNewBalanceNil = newBalance.trimmingCharacters(in: .whitespaces).isEmpty
                    if isNewBalanceNil {
                        newBalance = String(format: "%.2f", balance)
                    }

                    isEditingBalance.toggle()

                    if !isEditingBalance {
                        saveBalance()
                    }
                }) {
                    Text(isEditingBalance ? "Save" : "Edit")
                }
            }
        }
    }

    private func saveBalance() {
        let balanceObj = balances.first ?? Balance(context: viewContext)

        if let newBalanceFloat = Float(newBalance) {
            balanceObj.value = Int64((newBalanceFloat * 100).rounded(.towardZero))

        } else {
            balanceObj.value = 0
        }

        do {
            try viewContext.save()
        } catch {
            print("Error saving balance: \(error.localizedDescription)")
        }
    }

    private var balance: Float {
        if isEditingBalance {
            if let newBalanceFloat = Float(newBalance) {
                return newBalanceFloat
            } else {
                return 0.0
            }
        } else {
            if let balanceValue = balances.first?.value {
                return Float(balanceValue) / 100
            } else {
                return 0.0
            }
        }
    }
}

struct BalenceView_Previewrs: PreviewProvider {
    static var previews: some View {
        BalanceView()
    }
}
