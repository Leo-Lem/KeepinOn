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
            Section(~.settings) {
                TextField(~.projNamePlaceholder, text: $title.onChange(update))
                TextField(~.projDescPlaceholder, text: $details.onChange(update))
            }
            
            Section(~.projSelectColor) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))]) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }
            
            Section {
                Button(project.closed ? ~.projReopen : ~.projClose) {
                    project.closed.toggle()
                    update()
                }
                
                Button(~.projDelete, role: .destructive) { deleting = true }
            } footer: {
                Text(~.closeProjWarning) + Text(String(" ")) + Text(~.deleteProjWarning)
            }
            .alert(~Strings.deleteProjAlert.title, isPresented: $deleting) {
                Button(~.delete, role: .destructive, action: delete)
            } message: {
                Text(~Strings.deleteProjAlert.message)
            }
        }
        .navigationTitle(~.editProj)
        .onDisappear { try? dataController.save() }
    }
    
    @State private var title: String
    @State private var details: String
    @State private var color: String
    
    @State private var deleting = false
    
    init(_ project: Project) {
        self.project = project
        
        _title = State(initialValue: project.titleLabel)
        _details = State(initialValue: project.projectDetails)
        _color = State(initialValue: project.projectColor)
    }
    
}

private extension EditProjectView {
    
    func update() {
        project.title = title
        project.details = details
        project.color = color
    }
    
    func delete() {
        dataController.delete(project)
        dismiss()
    }
    
}

private extension EditProjectView {
    
    func colorButton(_ item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
            
            if item == color {
                Image(systemName: "checkmark.circle")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        .accessibilityLabel(~Strings.a11yColor(item))
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
