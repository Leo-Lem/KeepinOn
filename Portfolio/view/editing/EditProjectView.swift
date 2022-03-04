//
//  EditProjectView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct EditProjectView: View {
    
    @State var project: Project
    
    var body: some View {
        Content(project, update: update, delete: delete)
            .onDisappear(perform: dc.save)
    }
    
    @EnvironmentObject var dc: DataController
    
    func update(
        title: String,
        details: String,
        colorID: Project.ColorID,
        closed: Bool
    ) {
        project.update()
        
        if !title.isEmpty { project.title = title }
        project.details = details
        project.colorID = colorID
        project.closed = closed
    }
    
    @Environment(\.dismiss) var dismiss
    func delete() {
        dc.delete(project)
        dismiss()
    }
    
}
