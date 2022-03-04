//
//  Binding-onChange.swift
//
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

public extension Binding {

    /***/
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }

}
