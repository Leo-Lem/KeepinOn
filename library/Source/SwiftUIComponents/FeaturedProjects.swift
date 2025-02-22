// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct FeaturedProjects: View {
  let projects: [Project.WithItems]

  public var body: some View {
    LazyVGrid(columns: [GridItem()]) {
      ForEach(projects, id: \.project.id) { project in
        ProjectPeek(project)
          .onTapGesture { presented = project }
          .background {
            RoundedRectangle(cornerRadius: 10)
              .stroke(project.project.accent.color, lineWidth: 2)
              .rotationEffect(.degrees(3))
          }
      }
    }
    .padding(.horizontal)
    .padding()
    .accessibilityIdentifier("featured-projects-list")
    .sheet(item: $presented) { ProjectDetail($0) }
  }

  @State var presented: Project.WithItems?

  public init(_ projects: [Project.WithItems]) { self.projects = projects }
}

#Preview {
  FeaturedProjects([.init(.example(), items: [.example(), .example()]), .init(.example(), items: [])])
}
