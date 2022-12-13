// Created by Leopold Lemmermann on 08.12.22.

#if canImport(UIKit)
import UIKit
typealias XKitFont = UIFont
#elseif canImport(AppKit)
import AppKit
typealias XKitFont = NSFont
#endif
