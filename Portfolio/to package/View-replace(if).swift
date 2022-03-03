//
//  View-replace(if).swift
//
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

public extension View {
    
    /***/
    func replace<Content: View>(
        if condition: @autoclosure () -> Bool,
        placeholder: () -> Content
    ) -> some View {
        Group {
            if condition() {
                placeholder()
            } else {
                self
            }
        }
    }
    
    /***/
    func replace<S: StringProtocol>(
        if condition: @autoclosure () -> Bool,
        placeholder: S
    ) -> some View {
        Group {
            if condition() {
                Text(placeholder).foregroundColor(.secondary)
            } else {
                self
            }
        }
    }
    
    /***/
    func replace(
        if condition: @autoclosure () -> Bool,
        placeholder: LocalizedStringKey
    ) -> some View {
        Group {
            if condition() {
                Text(placeholder).foregroundColor(.secondary)
            } else {
                self
            }
        }
    }
    
}
