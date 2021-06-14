import Foundation

class StockMaximize {
  
  func countProfit(prices: [Int]) -> Int {
    if prices.isEmpty || prices.count <= 1 { return 0 }
    
    let count = prices.count
    var output = 0
    
    for i in 0..<count {
      var maxProfit = 0
      for j in i + 1..<count {
        let profit = prices[j] - prices [i]
        if profit > maxProfit {
          maxProfit = profit
        }
      }
      output += maxProfit
    }
    return output
  }
}
