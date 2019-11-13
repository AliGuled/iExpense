//
//  AddView.swift
//  iExpense
//
//  Created by Guled Ali on 10/11/2019.
//  Copyright © 2019 Guled Ali. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var expense: Expenses
    
   
    static let types = ["Business", "Personal"]
    var body: some View {
        NavigationView {
            Form {
                TextField("name", text: $name)
                
                Picker("type", selection: $type){
                    ForEach(AddView.self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("amount", text: $amount)
                    .keyboardType(.numberPad)
            }
        .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing:
                
                Button("Save") {
                    if let acualAmount = Double(self.amount) {
                        
                        let item = ExpenseItem(type: self.type, name: self.name, amount: acualAmount)
                        
                        self.expense.items.append(item)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }
                
            )
        }

    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expense: Expenses())
    }
}
