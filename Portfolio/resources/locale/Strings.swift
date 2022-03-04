//
//  I18n.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 02.03.22.
//

import SwiftUI

enum Strings: LocalizedStringKey, Localizable {
    case ok = "OK", // swiftlint:disable:this identifier_name
         delete = "DELETE",
         settings = "SETTINGS",
         emptyTabPlaceholder = "EMPTY_TAB_PLACEHOLDER"
    
    case home = "HOME",
         open = "OPEN",
         closed = "CLOSED",
         awards = "AWARDS",
         editProj = "EDIT_PROJECT",
         editItem = "EDIT_ITEM"
    
    case nextItems = "NEXT_ITEMS",
         moreItems = "MORE_ITEMS"
    static func items(_ count: Int) -> LocalizedStringKey { "ITEMS \(count)" }
    
    case locked = "LOCKED"
    static func unlocked(_ award: String) -> LocalizedStringKey { "UNLOCKED \(award)" }

    case openProjs = "OPEN_PROJECTS",
         closedProjs = "CLOSED_PROJECTS",
         addProj = "ADD_PROJECT",
         addItem = "ADD_ITEM",
         projPlaceholder = "PROJECTS_PLACEHOLDER"

    case sortLabel = "SORT_LABEL",
         optimizedSort = "OPTIMIZED_SORT",
         creationDateSort = "CREATIONDATE_SORT",
         titleSort = "TITLE_SORT"

    case projDefault = "PROJECT_DEFAULTNAME",
         itemDefault = "ITEM_DEFAULTNAME"

    case projNamePlaceholder = "PROJECT_NAME_PLACEHOLDER",
         projDescPlaceholder = "PROJECT_DESCRIPTION_PLACEHOLDER",
         projSelectColor = "PROJECT_SELECT_COLOR"

    case projClose = "CLOSE_PROJECT",
         projReopen = "REOPEN_PROJECT",
         projDelete = "DELETE_PROJECT"

    case closeProjWarning = "PROJECT_CLOSE_WARNING",
         deleteProjWarning = "PROJECT_DELETE_WARNING"
    static let deleteProjAlert: (
        title: LocalizedStringKey,
        message: LocalizedStringKey
    ) = ("PROJECT_DELETE_ALERT_TITLE", "PROJECT_DELETE_ALERT_MESSAGE")

    case itemNamePlaceholder = "ITEM_NAME",
         itemDescPlaceholder  = "ITEM_DESCRIPTION",
         markItemCompleted = "MARK_COMPLETED",
         priority = "PRIORITY"
    static let priorities: ( // swiftlint:disable:this large_tuple
        low: LocalizedStringKey,
        mid: LocalizedStringKey,
        high: LocalizedStringKey
    ) = ("PRIORITY_LOW", "PRIORITY_MID", "PRIORITY_HIGH")

    static func a11yDescription(
        project: String,
        items: Int,
        progress: Double
    ) -> LocalizedStringKey { "A11Y_COMPLETE_DESCRIPTION \(project) \(items) \(progress)" }
    static func a11yCompleted(project: String) -> LocalizedStringKey { "A11Y_COMPLETED \(project)"}
    static func a11yPriority(project: String) -> LocalizedStringKey { "A11Y_PRIORITY \(project)"}
    static func a11yColor(_ name: String) -> LocalizedStringKey {
        LocalizedStringKey(name.uppercased().replacingOccurrences(of: " ", with: "_"))
    }

    prefix static func ~ (_ arg: Self) -> LocalizedStringKey { arg.key }

}
