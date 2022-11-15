//	Created by Leopold Lemmermann on 10.11.22.

extension MutableCollection {
  func partitioning(
    by belongsInSecondPartition: (Element) throws -> Bool
  ) rethrows -> ([Element], [Element]) {
    let (first, second): (SubSequence, SubSequence) = try partitioning(by: belongsInSecondPartition)
    return (Array(first), Array(second))
  }
  
  func partitioning(
    by belongsInSecondPartition: (Element) throws -> Bool
  ) rethrows -> (SubSequence, SubSequence) {
    var mutableSelf = self
    
    let pivotIndex: Index = try mutableSelf.partition(by: belongsInSecondPartition)

    return (mutableSelf[..<pivotIndex], mutableSelf[pivotIndex...])
  }
}
