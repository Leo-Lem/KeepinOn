//	Created by Leopold Lemmermann on 10.10.22.

import SwiftUI

public extension View {
  /// Applies view transformations only if condition evaluates to true.
  /// ```
  /// Text("Hello, World!")
  ///     .if(myCondition) { view in
  ///         view.foregroundColor(.red)
  ///     }
  /// //returns red text if myCondition evaluates to true
  /// ```
  /// - Parameters:
  ///   - condition: A boolean value for when the transformation should be applied.
  ///   - transform: A function parameter taking a view of Self type as parameter and returning some View Content.
  /// - Returns: Some View, based on input parameters and Self type.
  @ViewBuilder func `if`<Content: View>(
    _ condition: @autoclosure () -> Bool,
    @ViewBuilder transform: (Self) -> Content
  ) -> some View {
    if condition() { transform(self) } else { self }
  }

  /// Applies view transformations only if condition evaluates to true.
  /// ```
  /// Text("Hello, World!")
  ///     .if(myCondition) { view in
  ///         view.foregroundColor(.red)
  ///     } else: { view in
  ///         view.font(.headline)
  ///     }
  /// //returns red text if myCondition evaluates to true,
  /// //otherwise text with headline font
  /// ```
  /// - Parameters:
  ///   - condition: A boolean value for when the transformation should be applied.
  ///   - transform: A function parameter taking a view of Self type as parameter and returning some View Content.
  ///   - else: Another function parameter taking a view of Self type as parameter and returning some View Content.
  /// - Returns: Some View, based on input parameters and Self type.
  @ViewBuilder func `if`<C1: View, C2: View>(
    _ condition: @autoclosure () -> Bool,
    @ViewBuilder transform: (Self) -> C1,
    @ViewBuilder else transform2: (Self) -> C2
  ) -> some View {
    if condition() { transform(self) } else { transform2(self) }
  }

  /// Applies view transformations if a value is non-optional and provides the value in the transformation closure.
  /// ```
  /// Text("Hello, World!")
  ///     .if(let: anOptionalString) { view, unwrappedOptionalString in
  ///         view.navigationTitle(unwrappedOptionalString)
  ///     }
  /// //adds a navigationtitle displaying the unwrapped String if it is not nil
  /// ```
  /// - Parameters:
  ///   - optional: An optional parameter of arbitrary type.
  ///   - condition: An optional boolean condition, that (if not nil)
  ///   will additionally determine whether to apply the transformation.
  ///   - transform: A function parameter taking a view of Self type as parameter and returning some View Content.
  /// - Returns: Some View, based on the provided optional, transformation function and Self type.
  @ViewBuilder func `if`<T, Content: View>(
    `let` optional: T?,
    and condition: Bool? = nil,
    @ViewBuilder transform: (Self, T) -> Content
  ) -> some View {
    switch (optional, condition) {
    case (.some, .none), (.some, true): transform(self, optional!)
    default: self
    }
  }

  /// Applies view transformations if a value is non-optional and provides the value in the transformation closure.
  /// ```
  /// Text("Hello, World!")
  ///     .if(let: anOptionalString) { view, unwrappedOptionalString in
  ///         view.navigationTitle(unwrappedOptionalString)
  ///     } else: { view in
  ///         view.foregroundColor(.red)
  ///     }
  /// //adds a navigationtitle displaying the unwrapped String if it is not nil
  /// //otherwise changes the foregroundColor of the Text to red
  /// ```
  /// - Parameters:
  ///   - optional: An optional parameter of arbitrary type.
  ///   - condition: An optional boolean condition, that (if not nil)
  ///   will additionally determine whether to apply the transformation.
  ///   - transform: A function parameter taking a view of Self type as parameter and returning some View Content.
  ///   - else: Another function parameter taking a view of Self type as parameter and returning some View Content.
  /// - Returns: Some View, based on the provided optional, transformation function and Self type.
  @ViewBuilder func `if`<T, C1: View, C2: View>(
    `let` optional: T?,
    and condition: Bool? = nil,
    @ViewBuilder transform: (Self, T) -> C1,
    @ViewBuilder else transform2: (Self) -> C2
  ) -> some View {
    switch (optional, condition) {
    case (.none, _), (.some, false): transform2(self)
    case (.some, .none), (.some, true): transform(self, optional!)
    default: self
    }
  }
}
