//
//  EditProjectVM.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import Foundation
import UIKit

extension EditProjectView {
    @MainActor final class ViewModel: ObservableObject {
        
        private let state: AppState
        private let dismiss: () -> Void
        private var project: Project
        
        @Published var title: String
        @Published var details: String
        @Published var colorID: ColorID
        @Published var reminder: Date?
        
        @Published var reminderError: Bool = false
        
        init(
            appState: AppState,
            dismiss: @escaping () -> Void,
            project: Project
        ) {
            state = appState
            self.dismiss = dismiss
            self.project = project
            
            self.title = project.title ?? ""
            self.details = project.details
            self.colorID = project.colorID
            self.reminder = project.reminder
        }
        
    }
}

extension EditProjectView.ViewModel {
    
    var closed: Bool {
        get { project.closed }
        set {
            project.closed = newValue
            save()
            
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.state.screen = (self.project.closed ? .closed : .open)
            }
        }
    }
    
    func updateProject() {
        project.willChange()
        
        if !self.title.isEmpty { project.title = self.title }
        
        project.details = self.details
        project.colorID = self.colorID
        
        project.reminder = reminder
        
        Task {
            if reminder != nil {
                guard await state.notificationController.addReminders(for: project) else {
                    project.reminder = nil
                    reminder = nil
                    
                    self.reminderError = true
                    return
                }
            } else {
                await state.notificationController.removeReminders(for: project)
            }
        }
        
        save()
        
        dismiss()
    }
    
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsURL) { UIApplication.shared.open(settingsURL) }
    }
    
    func delete() {
        state.dataController.delete(project)
        state.qaController.delete(project)
        
        save()
        
        dismiss()
    }
    
    private func save() { state.dataController.save() }
    
}
