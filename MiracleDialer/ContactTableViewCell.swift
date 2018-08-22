//
//  ContactTableViewCell.swift
//  MiracleDialer
//
//  Created by Oleg on 21/08/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(expanded: Bool, givenName: String, familyName: String) {
        if expanded {
            imgArrow.image = UIImage(named: "arrow_up")
        } else {
            imgArrow.image = UIImage(named: "arrow_down")
        }
        
        if givenName == "" {
            lblName.text = familyName
        } else {
            lblName.text = "\(givenName) \(familyName)"
        }
    }
}
