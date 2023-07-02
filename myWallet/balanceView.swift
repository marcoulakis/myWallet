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
    @State private var newCoin = ""


    var body: some View {
        Form {
            Section(header: Text("Financial Balance")) {
                HStack {
                    Text("Balance")
                    Spacer()
                    if isEditingBalance {
                        TextField("$$$", text: $newCoin)
                            .frame(width: 55)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                        TextField("New Balance", text: $newBalance)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .environment(\.layoutDirection, .rightToLeft)
                    } else {
                        Text("\(coin) \(balance, specifier: "%.2f")")
                    }
                }

                Button(action: {
                    let isNewBalanceNil = newBalance.trimmingCharacters(in: .whitespaces).isEmpty
                    if isNewBalanceNil {
                        newBalance = String(format: "%.2f", balance)
                    }
                    let isNewCoinNil = newCoin.trimmingCharacters(in: .whitespaces).isEmpty
                    if isNewCoinNil {
                        newCoin = coin
                    }

                    isEditingBalance.toggle()

                    if !isEditingBalance {
                        saveBalance()
                        saveCoin()
                    }
                }) {
                    Text(isEditingBalance ? "Save" : "Edit")
                }
            }
        }
    }

    private func saveBalance() {
        let balanceObj = balances.first ?? Balance(context: viewContext)

        let cleanedBalanceString = newBalance
            .replacingOccurrences(of: ",", with: ".")

        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."

        if let newBalanceFloat = numberFormatter.number(from: cleanedBalanceString)?.floatValue {
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
    
    private func saveCoin() {
        let balanceObj = balances.first ?? Balance(context: viewContext)

        balanceObj.coin = newCoin

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
    
    private var coin: String {
        if isEditingBalance {
            return String(newCoin)
        } else {
            if let balanceCoin = balances.first?.coin {
                return balanceCoin
            } else {
                return "$"
            }
        }
    }
}

struct BalenceView_Previewrs: PreviewProvider {
    static var previews: some View {
        BalanceView()
    }
}
