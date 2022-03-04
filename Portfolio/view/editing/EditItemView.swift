//
//  EditItemView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI
import MySwiftUI

struct EditItemView: View {
    
    @State var item: Item
    
    var body: some View {
        Content(item, update: update)
            .onDisappear(perform: dc.save)
    }
    
    @EnvironmentObject var dc: DataController
    
    private func update(
        title: String,
        details: String,
        priority: Item.Priority,
        completed: Bool
    ) {
        item.update()
        
        if !title.isEmpty { item.title = title }
        item.details = details
        item.priority = priority
        item.completed = completed
    }
    
}
