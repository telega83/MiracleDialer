//
//  DialpadButton.swift
//  MiracleDialer
//
//  Created by Oleg on 22/08/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class DialpadButton: UIButton {
    //Change color while highlited
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.lightGray : UIColor.white
        }
    }
    
    //Circular shape and border
    override func awakeFromNib() {
        layer.masksToBounds = true
        layer.cornerRadius = (frame.width / 2)
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
