//
//  balanceView.swift
//  myWallet
//
//  Created by Marcoulakis on 14/05/23.
//

import SwiftUI


struct BalanceView: View {
    @Environment (\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @FetchRequest(entity: Balance.entity(), sortDescriptors: []) var balances: FetchedResults<Balance>

    @State private var isEditingBalance = false
    @State private var newBalance = ""

    var body: some View {
        Form{
            Section(header: Text("Bank account")) {
                HStack {
                    Text("Balance")
                    Spacer()
                    if isEditingBalance {
                        TextField("New Balance", text: $newBalance)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minWidth: 100, idealWidth: 120, maxWidth: 120)
                    }else{
                        Text("R$ \(balance, specifier: "%.2f")")
                    }
                }

                Button(action: {
                    let isNewBalanceNil = (newBalance.trimmingCharacters(in: .whitespaces) == "")
                    if(isNewBalanceNil){
                        newBalance = String(balance)
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
        balanceObj.value = Double($newBalance.wrappedValue.doubleValue)
        do {
            try viewContext.save()
        } catch {
            print("Error saving balance: \(error.localizedDescription)")
        }
    }
    
    private var balance: Double {
        if isEditingBalance {
            return Double(newBalance) ?? 0.0
        } else {
            return balances.first?.value ?? 0.0
        }
    }

}

struct BalenceView_Previewrs: PreviewProvider {
    static var previews: some View {
        BalanceView()
    }
}
