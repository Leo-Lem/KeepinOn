//
//  NotificationController.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 08.03.22.
//

import UserNotifications

final actor NotificationController {
    
    private var center: UNUserNotificationCenter { .current() }
    
    func addReminders(for project: Project) async -> Bool {
        let settings = await center.notificationSettings()
        
        switch settings.authorizationStatus {
        case .notDetermined:
            return (await self.requestNotifications() ? await self.placeReminders(for: project) : false)
        case .authorized:
            return await self.placeReminders(for: project)
        default:
            return false
        }
    }
    
    func removeReminders(for project: Project) {
        let id = project.cd.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }

    private func requestNotifications() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound])
        } catch {
            return false
        }
    }

    private func placeReminders(for project: Project) async -> Bool {
        guard let reminder = project.reminder else { return false }
        
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = project.titleLabel
        
        if !project.details.isEmpty { content.subtitle = project.details }
        
        let comps = Calendar.current.dateComponents([.hour, .minute], from: reminder)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        
        let id = project.idString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        do {
            try await center.add(request)
            return true
        } catch {
            return false
        }
    }
    
}
