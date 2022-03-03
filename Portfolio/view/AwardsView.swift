//
//  AwardsView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct AwardsView: View {
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 100))]) {
                    ForEach(Award.allAwards) { award in
                        let unlocked = dataController.hasEarned(award: award)
                        
                        Button {
                            selected = award
                            selecting = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(unlocked ? Color(award.color) : .secondary.opacity(0.5))
                        }
                        .alert(unlocked ? ~Strings.unlocked(selected?.name ?? "") : ~.locked, isPresented: $selecting) {
                            Button(~.ok) {}
                        } message: {
                            Text(selected?.description ?? "")
                        }
                        .accessibilityLabel(unlocked ? ~Strings.unlocked(selected?.name ?? "") : ~.locked)
                        .accessibilityHint(award.description)
                    }
                }
            }
            .navigationTitle(~.awards)
        }
        .navigationViewStyle(.stack)
    }
    
    @State private var selected: Award?
    @State private var selecting = false
    
}

#if DEBUG
//MARK: - Previews
struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
            .environmentObject(dataController)
            .environment(
                \.managedObjectContext,
                 dataController.container.viewContext
            )
    }
}
#endif
