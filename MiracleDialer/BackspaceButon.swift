//
//  BackspaceButon.swift
//  MiracleDialer
//
//  Created by Oleg on 22/08/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class BackspaceButon: UIButton {
    //Change color while highlited
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.7 : 1
        }
    }
}
