//
//  ContactsViewController.swift
//  MiracleDialer
//
//  Created by Oleg on 20/08/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Allowed character set for phone numbers
    let allowedCharset = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "+"))
    
    var contactList = [ContactEntry]()
    var filteredContactList = [ContactEntry]()
    var contactListInUse = [ContactEntry]()
    
    func fetchContacts() {
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request an acces to user contacts: ", err)
                return
            }
            
            if granted {
                print("Access to user contacts is granted")
                let keys = [CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactTypeKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                request.sortOrder = CNContactSortOrder.userDefault
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        var phoneNumbers = [String]()
                        
                        for number in contact.phoneNumbers {
                            phoneNumbers.append(String(number.value.stringValue.unicodeScalars.filter(self.allowedCharset.contains)))
                        }
                        
                        if contact.contactType.rawValue == 1 {
                            self.contactList.append(ContactEntry(id: contact.identifier, expanded: false, givenName: "", familyName: "Apple Inc.", phoneNumbers: phoneNumbers))
                        } else {
                            
                            self.contactList.append(ContactEntry(id: contact.identifier, expanded: false, givenName: contact.givenName, familyName: contact.familyName, phoneNumbers: phoneNumbers))
                        }
                    })
                } catch let err {
                    print("Failed to enumerate contacts: ", err)
                }
                
                DispatchQueue.main.async {
                    self.contactListInUse = self.contactList
                    self.tableView.reloadData()
                }
            } else {
                print("Access to user contacts is denied")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {        
        return contactListInUse.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if contactListInUse[section].expanded {
            return contactListInUse[section].phoneNumbers.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ContactTableViewCell {
                cell.setupCell(expanded: contactListInUse[indexPath.section].expanded, givenName: contactListInUse[indexPath.section].givenName, familyName: contactListInUse[indexPath.section].familyName)
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "subcell", for: indexPath) as? PhoneNumberTableViewCell {
                cell.setupCell(phoneNumber: contactListInUse[indexPath.section].phoneNumbers[indexPath.row - 1])
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if contactListInUse[indexPath.section].expanded {
                contactListInUse[indexPath.section].expanded = false
                
                if let index = contactList.index(where: { $0.id == contactListInUse[indexPath.section].id }) {
                    contactList[index].expanded = false
                }
                
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                contactListInUse[indexPath.section].expanded = true
                
                if let index = contactList.index(where: { $0.id == contactListInUse[indexPath.section].id }) {
                    contactList[index].expanded = true
                }
                
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            contactListInUse = contactList
            tableView.reloadData()
        } else {
            contactListInUse = contactList.filter({$0.familyName.range(of: searchBar.text!.capitalized) != nil || $0.givenName.range(of: searchBar.text!.capitalized) != nil })
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    @objc func keyboardWasShown(_ notification : Notification) {
        let info = (notification as NSNotification).userInfo
        let value = info?[UIKeyboardFrameEndUserInfoKey]
        if let rawFrame = (value as AnyObject).cgRectValue
        {
            let keyboardFrame = self.tableView.convert(rawFrame, from: nil)
            let keyboardHeight = keyboardFrame.height
            var contentInsets : UIEdgeInsets
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0)
            
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(_ notification : Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.layer.cornerRadius = 5
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
        fetchContacts()
    }
}
