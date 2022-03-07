//
//  AwardsView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI

struct AwardsView: View {
        
    var body: some View {
        ScrollView {
            LazyVGrid(columns: cols) {
                ForEach(Award.allAwards) { award in
                    AwardView(award: award, unlocked: vm.isUnlocked(award))
                        .onTapGesture {
                            selected = award
                            selecting = true
                        }
                        .alert(
                            vm.isUnlocked(selected ?? award) ? ~.unlocked(selected?.name ?? "") : ~.locked,
                            isPresented: $selecting
                        ) {
                            Button(~.ok) {}
                        } message: {
                            Text(selected?.description ?? "")
                        }
                }
            }
        }
        .navigationTitle(~.navTitle(.awards))
        .embedInNavigation()
        .navigationViewStyle(.stack)
    }
    
    @State private var selected: Award?
    @State private var selecting = false
    private let cols = [GridItem(.adaptive(minimum: 100, maximum: 100))]
    
    @StateObject private var vm: ViewModel
    init(appState: AppState) {
        let vm = ViewModel(appState: appState)
        _vm = StateObject(wrappedValue: vm)
    }
    
}

// MARK: - (Previews)
struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView(appState: .preview)
    }
}
