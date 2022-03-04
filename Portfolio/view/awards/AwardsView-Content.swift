//
//  AwardsView-Content.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI

extension AwardsView {
    struct Content: View {
        
        let unlocked: (Award) -> Bool
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: cols) {
                    ForEach(Award.allAwards) { award in
                        AwardView(award: award, unlocked: unlocked(award))
                            .onTapGesture {
                                selected = award
                                selecting = true
                            }
                            .alert(
                                unlocked(award) ? ~Strings.unlocked(selected?.name ?? "") : ~.locked,
                                isPresented: $selecting
                            ) {
                                Button(~.ok) {}
                            } message: {
                                Text(selected?.description ?? "")
                            }
                    }
                }
            }
            .navigationTitle(~.awards)
            .embedInNavigation()
            .navigationViewStyle(.stack)
        }
        
        @State private var selected: Award?
        @State private var selecting = false
        
        private let cols = [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
}

#if DEBUG
// MARK: - (Previews)
// swiftlint:disable:next type_name
struct AwardsView_Content_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView.Content {_ in false}
    }
}
#endif
