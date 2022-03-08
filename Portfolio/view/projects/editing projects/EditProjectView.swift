//
//  EditProjectView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 04.03.22.
//

import SwiftUI
import MySwiftUI
import CoreHaptics

struct EditProjectView: View {
    
    let project: Project
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View { Content(vm: ViewModel(appState: state, dismiss: { dismiss() }, project: project)) }
    
    struct Content: View {
        
        @StateObject var vm: ViewModel
        
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
                
                if !vm.closed {
                    Section(~.projReminders) {
                        OptionalPicker($vm.reminder.animation(), default: Date.now + 60) {
                            Toggle(~.projShowReminders, isOn: $0)
                        } picker: {
                            DatePicker(
                                ~.projReminderTime,
                                selection: $0,
                                in: $1...,
                                displayedComponents: .hourAndMinute
                            )
                        }
                    }
                }
                
                Section {
                    Button(vm.closed ? ~.projReopen : ~.projClose, action: toggleClosed)
                    Button(~.projDelete, role: .destructive) {
                        deleteAlert = (~.deleteProjAlertTitle, ~.deleteProjAlertMessage)
                    }
                } footer: {
                    Text(~.deleteProjWarning)
                }
                .group { $0
                    .alert(
                        $deleteAlert,
                        title: { $0.title },
                        actions: { _ in Button(~.delete, role: .destructive, action: { vm.delete() }) },
                        message: { Text($0.message) }
                    )
                    .alert(
                        ~.reminderErrorTitle,
                        isPresented: $vm.reminderError,
                        actions: {
                            Button(~.ok) {}
                            Button(~.checkSettings, action: { vm.showAppSettings() })
                        },
                        message: { Text(~.reminderErrorMessage) }
                    )
                }
            }
            .toolbar {
                Button("Save", action: { vm.updateProject() })
            }
            .navigationTitle(~.editProj)
        }
        
        @State private var deleteAlert: (title: LocalizedStringKey, message: LocalizedStringKey)?
        
        @State private var engine = try? CHHapticEngine()
        
    }
    
}

private extension EditProjectView.Content {
    
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
    
    func toggleClosed() {
        vm.closed.toggle()
        
        if vm.closed {
            do {
                try engine?.start()
                let player = try engine?.makePlayer(with: try .taDa())
                try player?.start(atTime: 0)
           } catch {}
       }
    }
    
}
    
// MARK: - (Previews)
struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: .example)
            .environmentObject(AppState.preview)
    }
}
