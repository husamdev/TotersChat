//
//  ChatViewController.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import UIKit
import MessageViewController
import RealmSwift
import PromiseKit

class ChatViewController: MessageViewController {
    
    let viewModel = ChatViewModel()
    var conversation: Conversation!
    
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
        MessagingService.shared.resendMessageSubject.addObserver(observer: self)
        
        viewModel.getChatMessages(contact: conversation.contact).done(on: .main) { [weak self] _ in
            self?.tableView.reloadData()
        }
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
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        
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
        
        let message = ChatMessage()
        message.text = text
        message.receiverId = conversation.contact.id
        message.senderId = Contact.me.id
        message.isSend = true
        
        viewModel.messages.insert(message, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        tableView.endUpdates()
        
        MessagingService.shared.sendMessage(message)
        messageView.text = ""
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:
            MessageTableViewCell.self)) as? MessageTableViewCell else { return UITableViewCell() }
        cell.transform = tableView.transform
        cell.updateCell(message: viewModel.messages[indexPath.row])
        cell.setImage(conversation.contact.image)
        return cell
    }
}

extension ChatViewController: Observer {
    var id: Int {
        return 1
    }
    
    func update<T>(with newValue: T) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.messages.insert(newValue as! ChatMessage, at: 0)
            
            self?.tableView.beginUpdates()
            self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            self?.tableView.endUpdates()
        }
    }
}
