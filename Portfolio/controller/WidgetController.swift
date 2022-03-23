//
//  WidgetController.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 14.03.22.
//

import WidgetKit

final class WidgetController {
    
    func updateAllWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
}
