import UIKit
// Subscript String Extension
/// Drawbacks are that this is a very slow process.

//MARK: - Part 1
//let name = "Taylor"
//
//for letter in name {
//    print("Give me a \(letter)!")
//}
//
//let letter = name[name.index(name.startIndex, offsetBy: 3)]


//extension String {
//    subscript(i: Int) -> String {
//        return String(self[index(startIndex, offsetBy: i)])
//    }
//}
//
//let letter2 = name[3]


//MARK: - Part 2 & 3

//let password = "12345"
//password.hasPrefix("123")
//password.hasSuffix("45")
//
//extension String {
//    func deletingPrefix(_ prefix: String) -> String {
//        guard self.hasPrefix(prefix) else { return self }
//        return String(self.dropFirst(prefix.count))
//    }
//
//    func deletingSuffix(_ suffix: String) -> String {
//        guard self.hasSuffix(suffix) else { return self }
//        return String(self.dropLast(suffix.count))
//    }
//}


//let weather = "it's going to rain"
//print(weather.capitalized)
//
//extension String {
//    var capitalizedFirst: String {
//        guard let firstLetter = self.first else { return "" }
//        return firstLetter.uppercased() + self.dropFirst()
//    }
//}
//weather.capitalizedFirst


//let input = "Swift is like Objective-C without the C"
//input.contains("Swift")
//
//let languages = ["Python", "Ruby", "Swift"]
//languages.contains("Swift")
//
//extension String {
//    func containsAny(of array: [String]) -> Bool {
//        for item in array {
//            if self.contains(item){
//                return true
//            }
//        }
//        return false
//    }
//}
//
//input.containsAny(of: languages)
//
//languages.contains(where: input.contains)

//MARK: - Part 4


//let string = "This is a test string"
//let attributes: [NSAttributedString.Key: Any] = [
//    .foregroundColor : UIColor.white,
//    .backgroundColor : UIColor.red,
//    .font: UIFont.boldSystemFont(ofSize: 36)
//]
//let attributedString = NSAttributedString(string: string, attributes: attributes)

//let string = "This is a test string"
//let attributedString = NSMutableAttributedString(string: string)
//
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))



//MARK: - Challenges

// Challenge 1
var pet = "pet"
var carpet = "carpet"

pet.withPrefix("car")
carpet.withPrefix("car")

extension String {
    func withPrefix(_ word: String) -> String {
        guard !self.hasPrefix(word) else { return self }
        return word + self
    }
}

// Challenge 2
extension String {
    func isNumeric() -> Bool {
        // Check whole if the whole string has numbers
//        return Double(self) != nil
        // Check every char in string for a number
        for i in self {
            guard Double(String(i)) == nil else { return true }
        }
        return false
    }
}

var testString = "tehisshsfu"
var testString2 = "gnskdfghjh2gvdsf"
var testString3 = "1234"
testString.isNumeric()
testString2.isNumeric()
testString3.isNumeric()

// Challenge 3
extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

let seperated = "this\nis\na\ntest"
let seperated2 = """
this
is
a
test
"""

seperated.lines
seperated2.lines
