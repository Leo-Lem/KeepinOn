//
//  EditProjectView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI

struct EditProjectView: View {
    
    var body: some View {
        Form {
            Section(~.settings) {
                TextField(~.projNamePlaceholder, text: $vm.title)
                TextField(~.projDescPlaceholder, text: $vm.details)
            }
            
            Section(~.projSelectColor) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))]) {
                    ForEach(ColorID.allCases, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }
            
            Section {
                Button(vm.closed ? ~.projReopen : ~.projClose, primitiveAction: .toggle($vm.closed))
                Button(~.projDelete, role: .destructive) {
                    deleteAlert = (~.deleteProjAlertTitle, ~.deleteProjAlertMessage)
                }
            } footer: {
                Text(~.deleteProjWarning)
            }
            .alert($deleteAlert) {
                $0.title
            } actions: { _ in
                Button(~.delete, role: .destructive) {
                    vm.delete()
                    dismiss()
                }
            } message: { Text($0.message) }
        }
        .toolbar {
            Button("Save") {
                vm.updateProject()
                dismiss()
            }
        }
        .navigationTitle(~.navTitle(.editProj))
    }
    
    @State private var deleteAlert: (title: LocalizedStringKey, message: LocalizedStringKey)?
    
    @StateObject private var vm: ViewModel
    
    init(appState: AppState, project: Project) {
        let vm = ViewModel(appState: appState, project: project)
        _vm = StateObject(wrappedValue: vm)
    }
    
    @Environment(\.dismiss) var dismiss
    
}

private extension EditProjectView {
    
    func colorButton(_ id: ColorID) -> some View {
        Button(systemImage: "checkmark.circle") { vm.colorID = id }
            .buttonStyle(.borderless) // otherwise the buttons can't be individually clicked in a list
            .font(.largeTitle)
            .foregroundColor(vm.colorID == id ? .primary : .clear)
            .padding(5)
            .background {
                id.color
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(6)
            }
            .group { $0
                .if(vm.colorID == id) { $0.accessibilityAddTraits(.isSelected) }
                .accessibilityLabel(~.a11y(.color(id)))
            }
    }
    
}
    
// MARK: - (Previews)
struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(appState: .preview, project: .example)
    }
}
