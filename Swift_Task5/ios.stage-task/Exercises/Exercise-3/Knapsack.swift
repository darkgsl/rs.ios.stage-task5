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
    var output = 0
    if maxWeight > 2500 || foods.count == 0 || foods.count > 100 || drinks.count == 0 || drinks.count > 100 {
      return -1
    }

    let foodsDynamicTable : [[Element]] = makeDynamicTable(items: foods)
    let drinkDynamicTable : [[Element]] = makeDynamicTable(items: drinks)

    foodsDynamicTable[1].reversed().enumerated().forEach {(index, food) in
      let freeWeight = maxWeight - food.weight
      if freeWeight > 0 {
        
        if let columnWithWeight = findColumn2(arrayHeader: drinkDynamicTable[0], weight: freeWeight) {
          let drink = drinkDynamicTable[1][columnWithWeight]
          let maxValue =  min(food.value, drink.value)
          if maxValue > output {
            output = maxValue
          }
        }
      }
    }
    
    return output
  }
  func findColumn(arrayHeader : [Element], weight: Int ) -> Int? {
    //просто возвращаем индекс
    var returnIndex : Int?
    arrayHeader.enumerated().forEach { (index, value) in
      if value.weight  == weight {
        returnIndex = index
      }
    }
    return returnIndex
  }
  
  func findColumn2(arrayHeader : [Element], weight: Int ) -> Int? {
    
    var returnIndex : Int?
    arrayHeader.enumerated().forEach{(index, value) in
      if value.weight == weight {
        returnIndex = index
      }
    }
    return returnIndex
  }
  
  func makeDynamicTable(items: [Supply])->[[Element]] {
    
    guard let minWeightFood: Int = items.min(by: { $0.weight < $1.weight })?.weight else { return [[]] }
    let  maxWeightFood =  maxWeight //  self.maxMy
    var tableFoods : [[Element]] = []
    var arrayHeader: [Element] = []
    
    for weight in minWeightFood...maxWeightFood {
      let element = Element(weight: weight)
      arrayHeader.append(element)
    }
    arrayHeader.insert(Element(), at: 0)
    tableFoods.append(arrayHeader)
    
    var i = 1
    items.enumerated().forEach { indexMeal, valueMeal in
      var array: [Element] = []
      var element = Element(weight: valueMeal.weight, value: valueMeal.value)
      
      tableFoods[0].enumerated().forEach { indexHeader, valueHeader in
        
        if indexHeader != 0 {
          
          var currentValue : Element = Element()
          if  valueMeal.weight <= valueHeader.weight {
            currentValue.weight = valueMeal.weight
            currentValue.value = valueMeal.value
            let freeValue = abs(valueHeader.weight - valueMeal.weight)
            if freeValue >= minWeightFood {
              let prevRow = i - 1
              if let columnWithWeight = findColumn(arrayHeader: arrayHeader, weight: freeValue) {
                if prevRow >= 1 {
                  let additionalValue = tableFoods[prevRow][columnWithWeight]
                  if additionalValue.weight != -1 {
                    currentValue.weight += additionalValue.weight
                    currentValue.value += additionalValue.value
                    
                  }
                }
              }
            }
          }
          
          var previousValue : Element = Element()
          let prevRow = i - 1
          if prevRow >= 1 {
            previousValue = tableFoods[prevRow][indexHeader]
          }
          
          if currentValue.value > previousValue.value {
            element = currentValue
          } else {
            element = previousValue
          }
        }
        array.append(element)
        
      }
      tableFoods.append(array)
      i += 1
      
    }
    return [tableFoods[0],tableFoods[tableFoods.count - 1]]
  }
  
  
  
}
