//
//  EditProjectView-Content.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI

extension EditProjectView {
    struct Content: View {
        
        typealias UpdateClosure = (String, String, ColorID, Bool) -> Void // swiftlint:disable:this nesting
        typealias DeleteClosure = () -> Void // swiftlint:disable:this nesting
        
        let updateProject: UpdateClosure,
            delete: DeleteClosure
        
        var body: some View {
            Form {
                Section(~.settings) {
                    TextField(~.projNamePlaceholder, text: $title.onChange(update))
                    TextField(~.projDescPlaceholder, text: $details.onChange(update))
                }
                
                Section(~.projSelectColor) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))]) {
                        ForEach(ColorID.allCases, id: \.self, content: colorButton)
                    }
                    .padding(.vertical)
                }
                
                Section {
                    Button(closed ? ~.projReopen : ~.projClose, primitiveAction: .toggle($closed.onChange(update)))
                    Button(~.projDelete, role: .destructive, action: startDelete)
                } footer: {
                    Text(~.deleteProjWarning)
                }
                .alert($deleteAlert) {
                    $0.title
                } actions: { _ in
                    Button(~.delete, role: .destructive, action: delete)
                } message: { Text($0.message) }
            }
            .navigationTitle(~.navTitleEditProj)
        }
        
        @State private var title: String
        @State private var details: String
        @State private var colorID: ColorID
        @State private var closed: Bool
        
        @State private var deleteAlert: (title: LocalizedStringKey, message: LocalizedStringKey)?
        
        init(
            _ project: Project,
            update: @escaping UpdateClosure,
            delete: @escaping DeleteClosure
        ) {
            self.updateProject = update
            self.delete = delete
            
            _title = State(initialValue: project.title ?? "")
            _details = State(initialValue: project.details)
            _colorID = State(initialValue: project.colorID)
            _closed = State(initialValue: project.closed)
        }
        
        private func update() { updateProject(title, details, colorID, closed) }
        private func startDelete() { deleteAlert = (~.deleteProjAlertTitle, ~.deleteProjAlertMessage) }
        
    }
}

extension EditProjectView.Content {
    
    private func colorButton(_ id: ColorID) -> some View {
        Button(systemImage: "checkmark.circle") {
            colorID = id
            update()
        }
        .buttonStyle(.borderless) // otherwise the buttons can't be individually clicked in a list
        .font(.largeTitle)
        .foregroundColor(colorID == id ? .primary : .clear)
        .padding(5)
        .background {
            id.color
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
        }
        .group { $0
            .if(colorID == id) { $0.accessibilityAddTraits(.isSelected) }
            .accessibilityLabel(~.a11y(.color(id)))
        }
    }
    
}
    
// MARK: - (Previews)
// swiftlint:disable:next type_name
struct EditProjectView_Content_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView.Content(.example) {_, _, _, _ in} delete: {}
    }
}
