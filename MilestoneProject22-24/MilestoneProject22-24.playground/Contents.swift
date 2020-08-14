import UIKit

// Challenge 1

extension UIView {
    func bounceOut(duration: TimeInterval){
        UIView.animate(withDuration: duration) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

//let testView = UIView()
//testView.bounceOut(duration: 5)

// Challenge 2

extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        
        for _ in 0..<self {
            closure()
        }
    }
}

//6.times {
//    print("Hello!")
//}


// Challenge 3

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        guard let removeIndex = firstIndex(of: item) else { print("Element does not exist"); return }
        remove(at: removeIndex)
    }
}

//var numbers = [1, 2, 3, 4, 5]
//numbers.remove(item: 6)
