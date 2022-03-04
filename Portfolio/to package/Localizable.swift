//
//  Localizable.swift
//
//
//  Created by Leopold Lemmermann on 02.03.22.
//

import SwiftUI

/// Constrains types which can be used for localization.
public protocol Localizable {

    /// A key value pointing to the localized value (in the localized strings file or similar).
    var key: LocalizedStringKey { get }

}

public extension Localizable {

    /// Operator implementation returning given key.
    prefix static func ~ (_ arg: Self) -> LocalizedStringKey { arg.key }

}

public extension Localizable where Self: RawRepresentable, RawValue == LocalizedStringKey {

    /// Default implementation of the requirement key for enums with a raw value of String type.
    var key: LocalizedStringKey { rawValue }

}

public extension LocalizedStringKey {

    prefix static func ~ (_ arg: Self) -> LocalizedStringKey { arg }

    var key: String {
        let desc = "\(self)"

        let comp = desc.components(separatedBy: "key: \"").last,
            key = comp?.components(separatedBy: "\"").first

        return key ?? desc
    }

    func localize(_ id: String = Locale.current.languageCode ?? "en") -> String {
        guard
            let path = Bundle.main.path(forResource: id, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return String(localized: .init(key))
        }

        return String(localized: .init(key), bundle: bundle, locale: Locale(identifier: id))
    }

    init?(_ value: String?) {
        if let value = value { self.init(value) } else { return nil }
    }

}

public extension String {

    func localize(_ id: String = Locale.current.languageCode ?? "en") -> String {
        guard
            let path = Bundle.main.path(forResource: id, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return String(localized: .init(self))
        }

        return String(localized: .init(self), bundle: bundle, locale: Locale(identifier: id))
    }

}
