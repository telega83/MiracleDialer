//
//  ContactEntry.swift
//  MiracleDialer
//
//  Created by Oleg on 20/08/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import Foundation

struct ContactEntry {
    var id: String
    var expanded: Bool
    var givenName: String
    var familyName: String
    var phoneNumbers: [String]
}
