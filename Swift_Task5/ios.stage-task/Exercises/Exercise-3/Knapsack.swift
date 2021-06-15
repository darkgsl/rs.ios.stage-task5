import Foundation

public typealias Supply = (weight: Int, value: Int)

public final class Knapsack {
  
  let maxWeight: Int
  let drinks: [Supply]
  let foods: [Supply]
  var maxKilometers: Int {
    findMaxKilometres()
  }
  
  init(_ maxWeight: Int, _ foods: [Supply], _ drinks: [Supply]) {
    self.maxWeight = maxWeight
    self.drinks = drinks
    self.foods = foods
  }
  
  struct Element {
    var weight = -1
    var value = -1
    
  }
  func findMaxKilometres() -> Int {
    guard var output = checkLimits() else { return -1 }
    
    let foodsDynamicTable = makeTable(items: foods)
    let drinksDynamicTable = makeTable(items: drinks)

    for i in 1...maxWeight - 1 {
      let value = min(foodsDynamicTable[i], drinksDynamicTable[maxWeight - i])
      if value > output {
        output = value
      }
    }
    return output
  }
  func makeTable(items: [Supply])->[Int] {
    //create table with zeros
    var table: [[Int]] = Array(repeating: Array(repeating: (0) , count: maxWeight + 1), count: items.count + 1)

    for i in 1...items.count {
      for j in 1...maxWeight {
        var currentValue = 0
        if items[i - 1].weight <= j {
          // помещается в ячейку
          currentValue = items[i - 1].value + table[i - 1][j - items[i - 1].weight]
        }
        table[i][j] = max(currentValue, table[i - 1][j])
      }
    }
    return table[items.count]
  }
  
  func checkLimits()->Int?{
    var output: Int? = 0
    if maxWeight > 2500 || foods.count == 0 || foods.count > 100 || drinks.count == 0 || drinks.count > 100 {
      output = nil
    }
    return output
  }
}
