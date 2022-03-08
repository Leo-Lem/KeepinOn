//
//  Strings.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 02.03.22.
//

import SwiftUI
import MySwiftUI

enum Strings {
    
    case ok, delete, settings, dismiss,
         checkSettings, emptyTabPlaceholder
    
    case tab(_ tab: ContentView.Tab),
         navTitle(_ tab: ContentView.Tab),
         editProj, editItem
    
    case nextItems, moreItems, items(_ count: Int)
    
    case locked, unlocked(_ award: String)

    case addProj, addItem, projPlaceholder

    case sortLabel, sortOrder(_ order: Item.SortOrder)

    case projDefault, itemDefault

    case projNamePlaceholder, projDescPlaceholder, projSelectColor
    
    case projReminders, projShowReminders, projReminderTime,
         reminderErrorTitle, reminderErrorMessage

    case projClose, projReopen, projDelete

    case closeProjWarning, deleteProjWarning,
         deleteProjAlertTitle, deleteProjAlertMessage

    case itemNamePlaceholder, itemDescPlaceholder,
         markItemCompleted, priority,
         priorityLevel(_ level: Item.Priority)

    case iap(_ kind: IAP)
    
    enum IAP {
        case header, desc(_ price: String), restoreDesc
        case buy(_ price: String), restore
        case failure, loading, success, pending
    }
    
    case a11y(_ kind: A11Y)
    
    enum A11Y {
        case description(_ project: String, count: Int, progress: Double),
             completed(_ project: String),
             priority(_ project: String),
             color(_ id: ColorID)
    }

}

extension Strings: Localizable {
    
    prefix static func ~ (_ arg: Self) -> LocalizedStringKey { arg.key }
    
    var key: LocalizedStringKey {
        switch self {
        case .ok: return "OK"
        case .delete: return "DELETE"
        case .settings: return "DELETE"
        case .dismiss: return "DISMISS"
            
        case .checkSettings: return "CHECK_SETTINGS"
        case .emptyTabPlaceholder: return "EMPTY_TAB_PLACEHOLDER"
            
        case .tab(let tab):
            switch tab {
            case .home: return "HOME"
            case .open: return "OPEN"
            case .closed: return "CLOSED"
            case .awards: return "AWARDS"
            }
            
        case .nextItems: return "NEXT_ITEMS"
        case .moreItems: return "MORE_ITEMS"
        case .items(let count): return "ITEMS \(count)"
            
        case .locked: return "LOCKED"
        case .unlocked(let award): return "UNLOCKED \(award)"
            
        case .navTitle(let tab):
            switch tab {
            case .home: return "HOME"
            case .open: return "OPEN_PROJECTS"
            case .closed: return "CLOSED_PROJECTS"
            case .awards: return "AWARDS"
            }
            
        case .editProj: return "EDIT_PROJECT"
        case .editItem: return "EDIT_ITEM"
        case .addProj: return "ADD_PROJECT"
        case .addItem: return "ADD_ITEM"
        case .projPlaceholder: return "PROJECTS_PLACEHOLDER"
            
        case .sortLabel: return "SORT_LABEL"
        case .sortOrder(let order):
            switch order {
            case .title: return "TITLE_SORT"
            case .timestamp: return "CREATIONDATE_SORT"
            case .optimized: return "OPTIMIZED_SORT"
            }
            
        case .projDefault: return "PROJECT_DEFAULTNAME"
        case .itemDefault: return "ITEM_DEFAULTNAME"
            
        case .projNamePlaceholder: return "PROJECT_NAME_PLACEHOLDER"
        case .projDescPlaceholder: return "PROJECT_DESCRIPTION_PLACEHOLDER"
        case .projSelectColor: return "PROJECT_SELECT_COLOR"
            
        case .projReminders: return "PROJECT_REMINDERS"
        case .projShowReminders: return "PROJECT_SHOW_REMINDERS"
        case .projReminderTime: return "PROJECT_REMINDER_TIME"
        case .reminderErrorTitle: return "PROJECT_REMINDER_ERROR_TITLE"
        case .reminderErrorMessage: return "PROJECT_REMINDER_ERROR_MESSAGE"
            
        case .projClose: return "CLOSE_PROJECT"
        case .projReopen: return "REOPEN_PROJECT"
        case .projDelete: return "DELETE_PROJECT"
            
        case .closeProjWarning: return "PROJECT_CLOSE_WARNING"
        case .deleteProjWarning: return "PROJECT_DELETE_WARNING"
        case .deleteProjAlertTitle: return "PROJECT_DELETE_ALERT_TITLE"
        case .deleteProjAlertMessage: return "PROJECT_DELETE_ALERT_MESSAGE"
            
        case .itemNamePlaceholder: return "ITEM_NAME"
        case .itemDescPlaceholder: return "ITEM_DESCRIPTION"
        case .markItemCompleted: return "MARK_COMPLETED"
        case .priority: return "PRIORITY"
        case .priorityLevel(let priority):
            switch priority {
            case .low: return "PRIORITY_LOW"
            case .mid: return "PRIORITY_MID"
            case .high: return "PRIORITY_HIGH"
            }
            
        case .iap(let kind):
            switch kind {
            case .header: return "IAP_HEADLINE"
            case .desc(let price): return "IAP_DESCRIPTION \(price)"
            case .restoreDesc: return "IAP_RESTORE_DESCRIPTION"
                
            case .buy(let price): return "IAP_BUY_BUTTON \(price)"
            case .restore: return "IAP_RESTORE_BUTTON"
                
            case .failure: return "IAP_ERROR"
            case .loading: return "IAP_LOADING"
            case .success: return "IAP_SUCCESSFUL"
            case .pending: return "IAP_PENDING"
            }
            
        case .a11y(let kind):
            switch kind {
            case .description(let project, let count, let progress):
                return "A11Y_COMPLETE_DESCRIPTION \(project) \(count) \(progress)"
            case .completed(let project):
                return "A11Y_COMPLETED \(project)"
            case .priority(let project):
                return "A11Y_PRIORITY \(project)"
            case .color(let id):
                return LocalizedStringKey(id.rawValue.uppercased().replacingOccurrences(of: " ", with: "_"))
            }
        }
    }
    
}