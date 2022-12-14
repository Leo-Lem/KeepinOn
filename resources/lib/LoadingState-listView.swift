// Created by Leopold Lemmermann on 14.12.22.

import Concurrency
import SwiftUI

extension LoadingState where T: Identifiable {
  func listView<List: View>(@ViewBuilder list: @escaping ([T]) -> List) -> some View {
    ListView(self, list: list)
  }
  
  func listView<Row: View, P: View>(
    @ViewBuilder row: @escaping (T) -> Row, @ViewBuilder placeholder: @escaping () -> P
  ) -> some View {
    ListView(self, row: row, placeholder: placeholder)
  }
  
  struct ListView<Element: Identifiable, List: View>: View {
    let loadingState: LoadingState<Element>
    let list: ([Element]) -> List
    
    var body: some View {
      switch loadingState {
      case .idle:
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      case let .loading(elements), let .loaded(elements):
        list(elements)
        if loadingState.isLoading { ProgressView().frame(maxWidth: .infinity) }
      case let .failed(message):
        #if DEBUG
        if let message { Text(message) }
        #endif
      }
    }
    
    init(
      _ loadingState: LoadingState<Element>,
      @ViewBuilder list: @escaping ([Element]) -> List
    ) {
      self.loadingState = loadingState
      self.list = list
    }
    
    init<Row: View, P: View>(
      _ loadingState: LoadingState<Element>,
      @ViewBuilder row: @escaping (Element) -> Row,
      @ViewBuilder placeholder: @escaping () -> P
    ) where List == _ConditionalContent<P, ForEach<[Element], Element.ID, Row>> {
      self.loadingState = loadingState
      self.list = { ForEach($0, content: row).replaceIfEmpty(with: placeholder) }
    }
  }
}
