//
//  ProjectHeaderView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ProjectHeaderView: View {
    
    let project: Project
    @ObservedObject private var cd: Project.CD
    @EnvironmentObject var state: AppState

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.titleLabel)

                ProgressView(value: project.progress)
                    .tint(project.colorID.color)
            }

            Spacer()

            NavigationLink(destination: EditProjectView(project: project)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
                    .foregroundColor(project.colorID.color)
            }
            .accessibilityLabel(~.editProj)
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
    
    init(_ project: Project) {
        self.project = project
        cd = project.cd
    }
    
}

// MARK: - (Previews)
struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectHeaderView(.example)
        }
    }
}
