//
//  ContactsViewController.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/11/20.
//

import UIKit

class ContactsViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.frame = self.view.frame
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75
        tableView.allowsMultipleSelection = false
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: String(describing: ContactTableViewCell.self))
        return tableView
    }()
    
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getContacts()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getContacts() {
        let contactsService = ContactsCreatorService()
        contactsService.createContacts(count: 200).done(on: .main) { [weak self] contacts in
            self?.contacts = contacts
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactTableViewCell.self)) as? ContactTableViewCell else { return UITableViewCell() }
            
        cell.updateCell(name: contacts[indexPath.row].name, imageName: contacts[indexPath.row].image)
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension ContactsViewController: UITableViewDelegate {
    
}


