//
//  ContentView.swift
//  iExpense
//
//  Created by Guled Ali on 10/11/2019.
//  Copyright © 2019 Guled Ali. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let type: String
    let name: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        
        if let items = UserDefaults.standard.data(forKey: "Items") {
            
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
            self.items = decoded
            return
        }
    }
    
    self.items = []

    }
}
struct ContentView: View {
    
    @ObservedObject var expenses = Expenses()
    
    @State private var showingExpense = false
    
    var body: some View {
        NavigationView{
            
            List {
                ForEach(expenses.items) {  item in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        
                        Text("$\(item.amount, specifier: "%.2f")")
                    }
                }
                .onDelete(perform: removeItems)
            }
        .navigationBarTitle("iExpense")
        .navigationBarItems(trailing:
            
            Button(action: {
                
                self.showingExpense = true
                
                
            }) {
                Image(systemName: "plus")
            }
            
            
            )
            .sheet(isPresented: $showingExpense, content: {
                AddView(expense: self.expenses)
            })
        }
    }
    
    func removeItems(at offSets: IndexSet) {
        self.expenses.items.remove(atOffsets: offSets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
