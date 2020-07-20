//
//  ViewController.swift
//  Project18
//
//  Created by Leonardo Diaz on 7/19/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // seperator and terminator are both optional
        print(1,2,3,4,5, separator: "-")
        print("Some message", terminator: "")
        // Assert crashes if not true. Only visible in development code and removed in shipped code.
        assert(1 == 1, "Math failure!")
        
        
        for i in 1...100 {
            print("Got number \(i)")
        }
    }


}

