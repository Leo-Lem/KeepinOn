//
//  HomeView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Add Data") {
                    try? dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
    
}

#if DEBUG
//MARK: - Previews
struct HomeView_Previews: PreviewProvider {
    private static let dataController = DataController.preview
    
    static var previews: some View {
        HomeView()
            .environment(
                \.managedObjectContext,
                 dataController.container.viewContext
            )
            .environmentObject(dataController)
    }
}
#endif
