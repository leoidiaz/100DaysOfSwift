
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    ctx.cgContext.setBlendMode(.xor)

    UIColor.red.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 200, y: 200, width: 400, height: 400))
    ctx.cgContext.fillEllipse(in: CGRect(x: 400, y: 200, width: 400, height: 400))
    ctx.cgContext.fillEllipse(in: CGRect(x: 400, y: 400, width: 400, height: 400))
    ctx.cgContext.fillEllipse(in: CGRect(x: 200, y: 400, width: 400, height: 400))
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
