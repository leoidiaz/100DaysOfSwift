//
//  ViewController.swift
//  Project27
//
//  Created by Leonardo Diaz on 8/24/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var currentDrawType = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
    }
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            drawTwin()
        default:
            break
        }
    }
    
    func drawRectangle(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    
    func drawCheckerBoard(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0..<8 {
                for col in 0..<8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    
    func drawRotatedSquares(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            ctx.cgContext.translateBy(x: 256, y: 256)
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0..<rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
        }
        
        imageView.image = image
    }
    
    func drawLines(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            ctx.cgContext.translateBy(x: 256, y: 256)
            var first = true
            var length: CGFloat = 256
            
            for _ in 0..<256 {
                ctx.cgContext.rotate(by: .pi / 2 )
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    
    func drawImagesAndText(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment  = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            let string = "The best-laid schemes o'\nmice an' men aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    // Challenge 1
    func drawEmoji(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //😑
        let image = renderer.image { (ctx) in
            let rectangle = CGRect(x: 128, y: 128, width: 256, height: 256)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(2)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)

            // Create mouth
            let mouth = CGRect(x: 180, y: 296, width: 160, height: 10)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addRect(mouth)
            ctx.cgContext.drawPath(using: .fill)
            
            // Create Eye
            let leftEye = CGRect(x: 180, y: 220, width: 50, height: 10)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addRect(leftEye)
            ctx.cgContext.drawPath(using: .fill)
            
            // Create Eye
            let rightEye = CGRect(x: 288, y: 220, width: 50, height: 10)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addRect(rightEye)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        imageView.image = image
    }
    
    // Challenge 2
    func drawTwin(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //TWIN
        let image = renderer.image { (ctx) in
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.translateBy(x: 85, y: 0)
            // T
            ctx.cgContext.move(to: CGPoint(x: 125, y: 128))
            ctx.cgContext.addLine(to: CGPoint(x: 145, y: 128))
            ctx.cgContext.move(to: CGPoint(x: 135, y: 128))
            ctx.cgContext.addLine(to: CGPoint(x: 135, y: 150))
            
            // W
            ctx.cgContext.move(to: CGPoint(x: 155, y: 128))
            ctx.cgContext.addLine(to: CGPoint(x: 160, y: 150))
            ctx.cgContext.move(to: CGPoint(x: 160, y: 150))
            ctx.cgContext.addLine(to: CGPoint(x: 165, y: 130))
            ctx.cgContext.move(to: CGPoint(x: 165, y: 130))
            ctx.cgContext.addLine(to: CGPoint(x: 170, y: 150))
            ctx.cgContext.move(to: CGPoint(x: 170, y: 150))
            ctx.cgContext.addLine(to: CGPoint(x: 175, y: 128))
            
            // I
            ctx.cgContext.move(to: CGPoint(x: 185, y: 128))
            ctx.cgContext.addLine(to: CGPoint(x: 185, y: 150))
            
            // N
            ctx.cgContext.move(to: CGPoint(x: 195, y: 128))
            ctx.cgContext.addLine(to: CGPoint(x: 195, y: 150))
            ctx.cgContext.move(to: CGPoint(x: 195, y: 128))
            ctx.cgContext.addLine(to: CGPoint(x: 205, y: 150))
            ctx.cgContext.move(to: CGPoint(x: 205, y: 150))
            ctx.cgContext.addLine(to: CGPoint(x: 205, y: 128))
            
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
}
