//
//  ContentView.swift
//  SwiftUICoreData
//
//  Created by Siddharth on 26/04/21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        predicate: NSPredicate(format: "name == %@","Shirt")
    )var items: FetchedResults<Item>
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    )var categories: FetchedResults<Category>
    
    @State private var isActionSheetPresented = false
    @State private var isAlertPresented  = false
    
    var body: some View {
        VStack{
            Button(action: {
                let category = Category(context: managedObjectContext)
                category.name = "Clothes"
                PersistanceController.shared.save()
            }, label: {
                Text("Add Category")
            })
            Button(action: {
                if categories.count == 0{
                    isAlertPresented.toggle()
                }else{
                    isActionSheetPresented.toggle()
                }
            }, label: {
                Text("Add Item")
            })
            .actionSheet(isPresented: $isActionSheetPresented, content: {
                var buttons = [ActionSheet.Button]()
                categories.forEach { (category) in
                    let button = ActionSheet.Button.default(Text("\(category.name ?? "unknown")")) {
                        let item = Item(context: managedObjectContext)
                        item.name = "Shirt"
                        item.toCategory = category
                        PersistanceController.shared.save()
                    }
                    buttons.append(button)
                }
                buttons.append(.cancel())
                
                return ActionSheet(title: Text("Please select a category"), message: nil, buttons: buttons)
            })
            .alert(isPresented: $isAlertPresented, content: {
                Alert.init(title: Text("Please add a category"), message: nil, dismissButton: .cancel(Text("OK")))
            })
            List{
                ForEach(items,id:\.self){ item in
                    Text("\(item.name ?? "unknown") - \(item.toCategory?.name ?? "unknown")")
                }
                .onDelete(perform: removeItem(at:))
            }
            
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        for index in offsets{
            let item = items[index]
            PersistanceController.shared.delete(item)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
