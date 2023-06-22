//
//  infoView.swift
//  myWallet
//
//  Created by Marcoulakis ⠀ on 14/05/23.
//

import SwiftUI



struct InfoView: View {
    @Environment (\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @FetchRequest(entity: Balance.entity(), sortDescriptors: []) var balances: FetchedResults<Balance>

    
    @State var selectedItem: Item?
    @State var name: String
    @State var desc: String
    @State var purchaseDate: Date
    @State var value: Double
    @State var firstTime: Bool

    
    init(passedItem: Item?, initalDate: Date){
        if let item = passedItem{
            _selectedItem = State(initialValue: item)
            _name = State(initialValue: item.name ?? "")
            _desc = State(initialValue: item.desc ?? "")
            _purchaseDate = State(initialValue: item.purchaseDate ?? initalDate)
            _value = State(initialValue: item.value)
            _firstTime = State(initialValue: item.firstTime)
        }else{
            _name = State(initialValue: "")
            _desc = State(initialValue: "")
            _purchaseDate = State(initialValue: initalDate)
            _value = State(initialValue: 0)
            _firstTime = State(initialValue: true)
        }
    }
    
    func removeFromBalance(value: Float){
        let balanceObj = balances.first ?? Balance(context: viewContext)
         
        balanceObj.value -= Int64(value * 100)
        do {
            try viewContext.save()
        } catch {
            print("Error saving balance: \(error.localizedDescription)")
        }
    }
    
    func makeNumberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }

    
    var body: some View {


        
        Form{
            Section(header: Text("Purchase")){
                HStack{
                    Text("Store:").foregroundColor(.secondary)
                    TextField("Store", text: $name)
                }
                HStack{
                    Text("Product:").foregroundColor(.secondary)
                    TextField("Product", text: $desc)
                }
                DatePicker("Date:", selection: $purchaseDate, displayedComponents: displayComps())
                    .foregroundColor(.secondary)
                HStack{
                    Text("R$")
                    TextField("Price", value: $value, formatter: makeNumberFormatter())
                        .keyboardType(.decimalPad)
                }

            }
            Section(){
                Button("Save", action: saveAction)
                    .font(.headline)
            }
        }
    }
    func displayComps () -> DatePickerComponents{
        return [.hourAndMinute, .date]
    }
    func saveAction(){
        withAnimation{
            if selectedItem == nil{
                selectedItem = Item(context: viewContext)
            }
            if(firstTime){
                selectedItem?.firstTime = false
                removeFromBalance(value: Float(value))
            }else{
                if(selectedItem?.value != value){
                
                    let newValue = value - selectedItem!.value
                    
                    removeFromBalance(value: Float(newValue))

                }
            }
            
            print(value)
            selectedItem?.name = name
            selectedItem?.desc = desc
            selectedItem?.purchaseDate = purchaseDate
            selectedItem?.value = value
            
            dateHolder.saveContext(viewContext)
            self.presentationMode.wrappedValue.dismiss()
        }
    }

}

struct InfoView_Previewrs: PreviewProvider {
    static var previews: some View {
        InfoView(passedItem: Item(), initalDate: Date())
    }
}
