//
//  ContactsViewController.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/11/20.
//

import UIKit

class ContactsViewController: UIViewController {
    
    let conversationService = ConversationService()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.frame = self.view.frame
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75
        tableView.allowsMultipleSelection = false
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: String(describing: ContactTableViewCell.self))
        return tableView
    }()
    
    var conversations: [Conversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        _ = conversationService.getConversations().done(on: .main, { [weak self] conversations in
            self?.conversations = conversations
            self?.tableView.reloadData()
        })
    }
    
    func setupUI() {
        title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .myBlack
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

// MARK: - UITableViewDataSource
extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactTableViewCell.self)) as? ContactTableViewCell else { return UITableViewCell() }
        
        cell.updateCell(conversation: conversations[indexPath.row])
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = ChatViewController()
        chatViewController.conversation = conversations[indexPath.row]
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}


