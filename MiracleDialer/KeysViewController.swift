//
//  KeysViewController.swift
//  MiracleDialer
//
//  Created by Oleg on 22/08/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class KeysViewController: UIViewController {

    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnBackspace: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnZero: DialpadButton!
    
    @IBAction func btnNumberTapped(_ button: UIButton) {
        if button.tag == 10 {
            lblNumber.text = lblNumber.text! + "*"
        } else if button.tag == 11 {
            lblNumber.text = lblNumber.text! + "#"
        } else {
            lblNumber.text = lblNumber.text! + "\(button.tag)"
        }
    }
    
    @IBAction func btnBackspaceTapped(_ sender: Any) {
        if lblNumber.text != "" {
            lblNumber.text!.removeLast()
        }
    }
    
    @IBAction func numberWasChanged(_ sender: Any) {
        checkPhoneNumber()
    }
    
    @IBAction func btnCallTapped(_ sender: Any) {
        if let url = URL(string: "tel://\(lblNumber.text!)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func longTapZero(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            lblNumber.text!.removeLast()
            lblNumber.text = lblNumber.text! + "+"
            checkPhoneNumber()
        }
    }
    
    @objc func longTapBackspace(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            lblNumber.text! = ""
            checkPhoneNumber()
        }
    }
    
    func checkPhoneNumber() {
        if lblNumber.text! != "" {
            if lblNumber.text! != "+" {
                btnBackspace.isEnabled = true
                btnCall.isEnabled = true
            } else {
                btnBackspace.isEnabled = true
                btnCall.isEnabled = false
            }
        } else {
            btnBackspace.isEnabled = false
            btnCall.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Long gesture recognizer for 0 button for "+" symbol
        let longGestureZero = UILongPressGestureRecognizer(target: self, action: #selector(longTapZero(_:)))
        longGestureZero.minimumPressDuration = 1
        btnZero.addGestureRecognizer(longGestureZero)
        
        //Long gesture recognizer for backspace
        let longGestureBackspace = UILongPressGestureRecognizer(target: self, action: #selector(longTapBackspace(_:)))
        longGestureBackspace.minimumPressDuration = 1
        btnBackspace.addGestureRecognizer(longGestureBackspace)
    }
}
