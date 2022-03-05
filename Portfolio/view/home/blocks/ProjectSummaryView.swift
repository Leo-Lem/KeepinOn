//
//  ProjectSummaryView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 03.03.22.
//

import SwiftUI
import MySwiftUI

struct ProjectSummaryView: View {
    
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(~.items(project.items.count), font: .caption, color: .secondary)

            Text(project.titleLabel, font: .title2)

            ProgressView(value: project.progress)
                .tint(project.colorID.color)
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: .primary.opacity(0.2), radius: 5)
        .padding([.horizontal, .top])
        .group { $0
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(project.a11yLabel)
        }
    }
    
    @ObservedObject private var cd: Project.CDObject
    
    init(_ project: Project) {
        self.project = project
        cd = project.cd
    }
    
}

#if DEBUG
// MARK: - (Previews)
struct ProjectSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSummaryView(.example)
    }
}
#endif
