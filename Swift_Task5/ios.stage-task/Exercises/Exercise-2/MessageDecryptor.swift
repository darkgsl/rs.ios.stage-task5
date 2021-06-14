import UIKit

class MessageDecryptor: NSObject {
  var output = ""
  var array : [String.Element]  = []
  
  func decryptMessage(_ message: String) -> String {
    
    var allowed =  CharacterSet()
    allowed.formUnion(.alphanumerics)
    allowed.insert(charactersIn: "[]")
    if message.rangeOfCharacter(from: allowed.inverted) != nil {
      return ""
    }
    
    if message.count > 60 || message.count < 1 {
      return ""
    }
    
    let closeChar: Character = "]"
    let openChar: Character = "["
    //проверим количество пар
    let countCloseChar = message.reduce(0) { $1 == closeChar ? $0 + 1 : $0}
    let countOpenChar = message.reduce(0) { $1 == openChar ? $0 + 1 : $0}
    if  countCloseChar != countOpenChar { return "" }

    output = message
    
    array = Array(output)
    func dflow (start: Int, end: Int) {
      
      let subArray = array[start..<end]
      guard let firstOpenSB = subArray.firstIndex(of: openChar), let firstCloseSB = subArray.firstIndex(of: closeChar) else { return }
      
      if let secondOpenSB = subArray[subArray.index(after: firstOpenSB)...].firstIndex(of: openChar)  {
        if secondOpenSB < firstCloseSB {
          dflow(start: firstOpenSB + 1, end: array.count)
        } else {
          makeResult(firstOpenSB: firstOpenSB, firstCloseSB: firstCloseSB)
        }
      } else {
        makeResult(firstOpenSB: firstOpenSB, firstCloseSB: firstCloseSB)
      }
    }
    
    while array.contains(openChar) {
      let start = 0
      let end = array.count
      
      dflow(start: start, end: end)
    }
    let x = array.reduce("") { (result, num) -> String in
      result + String(num)
    }
    return x
  }

  func unwrap(arrayL : Array<String.Element>.SubSequence){
    let closeChar: Character = "]"
    let openChar: Character = "["
    

    var nextOpenIndex: Int?
    var firstCloseIndex: Int?
    while arrayL.contains(closeChar) {

      if let openIndex = arrayL.firstIndex(of: openChar) { //+1
        //проверим, дальше есть [
        let idx = array.index(after: openIndex)
        if array[idx...].contains(openChar) {

          nextOpenIndex = arrayL[idx...].firstIndex(of: openChar)
          firstCloseIndex = arrayL[idx...].firstIndex(of: closeChar)
          if nextOpenIndex ?? 0 < firstCloseIndex! {

            unwrap(arrayL: arrayL[idx...])
            return
          }
        }
        var indexCount = arrayL.index(before: openIndex)
        guard let closeIndex = arrayL.firstIndex(of: closeChar) else {return}
        
        var count = 1
        var subStr = array[openIndex...closeIndex]
        if indexCount >= 0 {
          count = Int(String(arrayL[indexCount]))!

        } else {
          indexCount = 0
        }
        subStr.removeFirst(1)
        subStr.removeLast()
        
        var str = subStr.reduce("") { (result, num) -> String in
          return result + String(num)
        }
        str = String.init(repeating: str, count: count)
        
        array.removeSubrange(indexCount...closeIndex)
        array.insert(contentsOf: Array(str), at: indexCount)

        return
       
      }
    }
    return
  }
  
  func makeResult(firstOpenSB: Int, firstCloseSB: Int) {
    var number = 1
    var count: Int = 0
    switch firstOpenSB {
    case 0:
      count = 0
    case 1:
      count = 1
    case 2:
      count = 2
    default:
      count = 3
    }
 
    for idx in (0...count).reversed() {
      if firstOpenSB - idx >= 0 {
        // т.е. не вышди за дипазон 0
        let range = firstOpenSB - idx..<firstOpenSB
        //print(array[range])
        if let value  = Int(String(array[range])) {
          //все , чсило повторений знаем
          number = value
          count = idx
          break
        }
      }
    }

    let subStr = array[firstOpenSB+1..<firstCloseSB]
    var str = subStr.reduce("") { (result, num) -> String in
      return result + String(num)
    }
    str = String.init(repeating: str, count: number)
    array.removeSubrange(firstOpenSB - count...firstCloseSB)
    array.insert(contentsOf: Array(str), at: firstOpenSB - count)

  }
}
