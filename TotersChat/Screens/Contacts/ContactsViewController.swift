//
//  ContactsViewController.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/11/20.
//

import UIKit
import UIScrollView_InfiniteScroll
import Lottie

class ContactsViewController: UIViewController {
    
    let conversationService = ConversationService()
    var page = 0
    
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
        setupInfinityScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        page = 0
        navigationController?.navigationBar.prefersLargeTitles = true
        
        conversations = []
        _ = conversationService.getConversations(page: page).done(on: .main, { [weak self] conversations in
            self?.conversations = conversations
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        })
    }
    
    func setupUI() {
        title = "Messages"
        
        view.backgroundColor = .myBlack
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupInfinityScroll() {
        let animation = Animation.named("loading2")
        let animationView = AnimationView(animation: animation)
        animationView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        animationView.loopMode = .loop
        animationView.play()
        
        tableView.infiniteScrollIndicatorView = animationView
        tableView.addInfiniteScroll { [weak self] tableView in
            self?.page += 1
            _ = self?.conversationService.getConversations(page: self?.page ?? 0).done(on: .main, { [weak self] conversations in
                self?.conversations.append(contentsOf: conversations)
                self?.tableView.reloadData()
            })
            
            tableView.finishInfiniteScroll()
        }
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


