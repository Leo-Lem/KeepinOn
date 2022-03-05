//
//  AwardView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI

struct AwardView: View {
    let award: Award,
        unlocked: Bool
    
    var body: some View {
        Image(systemName: award.image)
            .resizable()
            .scaledToFit()
            .padding()
            .frame(width: 100, height: 100)
            .foregroundColor(unlocked ? award.color.color : .secondary.opacity(0.5))
            .group { $0
                .accessibilityLabel(unlocked ? ~.unlocked(award.name) : ~.locked)
                .accessibilityHint(award.description)
            }
    }
}

// MARK: - (Previews)
struct AwardView_Previews: PreviewProvider {
    static var previews: some View {
        AwardView(award: .example, unlocked: false)
    }
}
