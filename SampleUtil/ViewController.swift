//
//  ViewController.swift
//  SampleUtil
//
//  Created by Bao Nguyen on 2020/06/30.
//  Copyright © 2020 Bao Nguyen. All rights reserved.
//

import UIKit
import SampleUtilLib

class ViewController: UIViewController {
    
    private var squareView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        squareView = UIView()
        self.view.addSubview(squareView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let center = self.view.center.applying(CGAffineTransform(translationX: -50, y: -50))
        squareView.frame = CGRect(origin: center,
                                  size: CGSize(width: 100, height: 100))
        squareView.cornerRadius = 10.0
        squareView.borderWidth = 1.0
        squareView.borderColor = .black
    }

}

