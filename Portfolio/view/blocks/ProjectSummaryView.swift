//
//  ProjectSummaryView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 03.03.22.
//

import SwiftUI

extension HomeView {
    struct ProjectSummary: View {
        @ObservedObject var project: Project
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(~Strings.items(project.projectItems.count))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(project.titleLabel)
                    .font(.title2)

                ProgressView(value: project.completionAmount)
                    .tint(Color(project.projectColor))
            }
            .padding()
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(10)
            .shadow(color: .primary.opacity(0.2), radius: 5)
            .padding([.horizontal, .top])
            
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(project.label)
        }
    }
}

struct ProjectSummary_Previews: PreviewProvider {
    static var previews: some View {
        HomeView.ProjectSummary(project: .example)
    }
}
