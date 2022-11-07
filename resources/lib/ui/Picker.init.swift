//	Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

extension Picker {
  init<S, Data, ID, ItemContent>(
    _ title: S,
    selection: Binding<SelectionValue>,
    items: Data,
    id: KeyPath<Data.Element, ID>,
    content: @escaping (Data.Element) -> ItemContent
  ) where
    Label == Text, S: StringProtocol,
    Content == ForEach<Data, ID, ItemContent>,
    Data: RandomAccessCollection,
    ID: Hashable,
    ItemContent: View
  {
    self.init(title, selection: selection, content: { ForEach(items, id: id, content: content) })
  }
}
