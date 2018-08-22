//
//  PhoneNumberTableViewCell.swift
//  MiracleDialer
//
//  Created by Oleg on 21/08/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class PhoneNumberTableViewCell: UITableViewCell {
    @IBOutlet weak var btnPhoneNumber: UIButton!
    
    var phoneNumber = String()
    
    @IBAction func btnPhoneNumberTapped(_ sender: Any) {
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupCell(phoneNumber: String) {
        btnPhoneNumber.setTitle(phoneNumber, for: UIControlState.normal)
        self.phoneNumber = phoneNumber
    }
}
