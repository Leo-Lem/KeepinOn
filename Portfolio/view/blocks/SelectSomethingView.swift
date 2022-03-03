//
//  SelectSomethingView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct SelectSomethingView: View {
    var body: some View {
        Text(~.emptyTabPlaceholder)
            .italic()
            .foregroundColor(.secondary)
    }
}

#if DEBUG
//MARK: - Previews
struct SelectSomethingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomethingView()
    }
}
#endif
