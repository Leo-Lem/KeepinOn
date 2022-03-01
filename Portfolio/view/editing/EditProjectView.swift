//
//  EditProjectView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct EditProjectView: View {
    
    let project: Project
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section("Basic settings") {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $details.onChange(update))
            }
            
            Section("Custom project color") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))]) {
                    ForEach(Project.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)
                            
                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.primary)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            color = item
                            update()
                        }
                    }
                }
                .padding(.vertical)
            }
            
            Section {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    update()
                }
                
                Button("Delete this project", role: .destructive) {
                    deleting = true
                }
            } footer: {
                Text("Closing a project moves it from the Open to the Closed tab; deleting it removes the project completely.")
            }
            .alert("Delete project?", isPresented: $deleting) {
                Button("Delete", role: .destructive, action: delete)
            } message: {
                Text("Are you sure you want to delete this project? You will also delete all the items it contains.")
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear { try? dataController.save() }
    }
    
    @State private var title: String
    @State private var details: String
    @State private var color: String
    
    @State private var deleting = false
    
    init(_ project: Project) {
        self.project = project
        
        _title = State(initialValue: project.projectTitle)
        _details = State(initialValue: project.projectDetails)
        _color = State(initialValue: project.projectColor)
    }
    
    private func update() {
        project.title = title
        project.details = details
        project.color = color
    }
    
    private func delete() {
        dataController.delete(project)
        dismiss()
    }
    
}

#if DEBUG
//MARK: - Previews
struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(.example)
            .environment(
                \.managedObjectContext,
                 dataController.container.viewContext
            )
            .environmentObject(dataController)
    }
}
#endif
