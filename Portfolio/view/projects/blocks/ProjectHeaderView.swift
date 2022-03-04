//
//  ProjectHeaderView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ProjectHeaderView: View {
    let project: Project

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.titleLabel)

                ProgressView(value: project.progress)
                    .tint(project.color)
            }

            Spacer()

            NavigationLink(destination: EditProjectView(project: project)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
    
    @ObservedObject private var cd: Project.CDObject
    
    init(_ project: Project) {
        self.project = project
        cd = project.cd
    }
    
}

#if DEBUG
// MARK: - (Previews)
struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectHeaderView(.example)
        }
    }
}
#endif
