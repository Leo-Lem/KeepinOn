//
//  ProjectHeaderView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)

                ProgressView(value: project.completionAmount)
                    .tint(Color(project.projectColor))
            }

            Spacer()

            NavigationLink {
                EditProjectView(project)
            } label: {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 10)
    }
}

#if DEBUG
//MARK: - Previews
struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectHeaderView(project: .example)
        }
    }
}
#endif
