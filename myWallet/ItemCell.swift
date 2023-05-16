//
//  ItemCell.swift
//  myWallet
//
//  Created by Marcoulakis ⠀ on 14/05/23.
//

import SwiftUI
extension Calendar {
    func daysBetween(start: Date, end: Date) -> Int {
        let fromDate = startOfDay(for: start) // <1>
         let toDate = startOfDay(for: end) // <2>
        return Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
    }
}


struct ItemCell: View {
    @EnvironmentObject var dateHolder: DateHolder
    @ObservedObject var passedItem: Item
    


    
    var body: some View{
        HStack{
            VStack(alignment: .leading, spacing: 0){
                Text((passedItem.name ?? ""))
                Text(passedItem.desc ?? "" ).font(.system(size: 14)).foregroundColor(.secondary)
                if(passedItem.purchaseDate != nil){
                    
                    let calendar = Calendar.current

                    if(((calendar.daysBetween(start: passedItem.purchaseDate ?? Date(),  end: Date()))) == 0){
                    
                        Text("Today").font(.system(size: 14)).foregroundColor(.secondary)
                        
                    }else if(((calendar.daysBetween(start: passedItem.purchaseDate ?? Date(),  end: Date()))) == 1){
                        
                        Text("Yesterday").font(.system(size: 14)).foregroundColor(.secondary)
                        
                    }else if(((calendar.daysBetween(start: passedItem.purchaseDate ?? Date(),  end: Date()))) >= 7){
                        
                        Text(passedItem.purchaseDate!
                            .formatted(date: .numeric, time: .omitted))
                        .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                    else{
                        Text(passedItem.purchaseDate!
                            .formatted(Date.FormatStyle().weekday(.wide)))
                        .font(.system(size: 14)).foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
            Text(String(format: "%.2f R$", passedItem.value))
        }

    }
}

struct ItemCell_Previewrs: PreviewProvider {
    static var previews: some View {
        ItemCell(passedItem: Item())
    }
}
