//
//  EditProjectVM.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

extension EditProjectView {
    final class ViewModel: ObservableObject {
        
        @Published var title: String
        @Published var details: String
        @Published var colorID: ColorID
        
        private var project: Project
        
        private let state: AppState
        private var dc: DataController { state.dataController }
        
        init(appState: AppState, project: Project) {
            state = appState
            
            self.project = project
            
            self.title = project.title ?? ""
            self.details = project.details
            self.colorID = project.colorID
        }
        
    }
}

extension EditProjectView.ViewModel {
    
    var closed: Bool {
        get { project.closed }
        set {
            project.closed = newValue
            state.screen = (project.closed ? .closed : .open)
        }
    }
    
    func updateProject() {
        project.update()
        
        if !self.title.isEmpty { project.title = self.title }
        
        project.details = self.details
        project.colorID = self.colorID
        
        if project.closed != self.closed {
            
        }
        
        save()
    }
    
    func delete() {
        dc.delete(project)
        
        save()
    }
    
    private func save() { dc.save() }
    
}
