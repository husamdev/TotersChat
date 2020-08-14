//
//  ChatViewController.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import UIKit
import MessageViewController
import RealmSwift

class ChatViewController: MessageViewController {
    
    var conversation: Conversation!
    var messages: [Message] = []
    
    var tableView: UITableView = {
        let t = UITableView()
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = UITableView.automaticDimension
        t.allowsSelection = false
        t.separatorStyle = .none
        t.backgroundColor = .clear
        t.register(MessageTableViewCell.self, forCellReuseIdentifier: String(describing: MessageTableViewCell.self))
        return t
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        title = conversation.contact.name
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .myBlack
        
        setupTableView()
        setup(scrollView: tableView)
        setupMessageView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func setupMessageView() {
        borderColor = .mylightBlack
        messageView.inset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 16)
        messageView.textView.placeholderText = "Type a message"
        messageView.textView.placeholderTextColor = .myBlack
        messageView.font = .systemFont(ofSize: 15)
        messageView.backgroundColor = .darkGray
        messageView.setButton(title: "Send", for: .normal, position: .right)
        messageView.addButton(target: self, action: #selector(sendMessage), position: .right)
        messageView.rightButtonTint = .myGreen
        messageView.tintColor = .myBlack
    }
    
    @objc func sendMessage() {
        let text = messageView.text
        
        let realm = try! Realm()
        
        let message = Message()
        message.text = text
        message.receiverId = conversation.contact.id
        
        try! realm.write {
            realm.add(message, update: .all)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:
            MessageTableViewCell.self)) as? MessageTableViewCell else { return UITableViewCell() }
        cell.updateCell(isSend: indexPath.row % 2 == 0)
        cell.textView.text = "hello how are you?"
        return cell
    }
}
