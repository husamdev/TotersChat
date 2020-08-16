//
//  ContactsViewController.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/11/20.
//

import UIKit
import Lottie

class ContactsViewController: UIViewController {
    
    let viewModel = ContactsViewModel()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getConversations()
    }
    
    func setupUI() {
        title = "Messages"
        
        view.backgroundColor = .myBlack
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getConversations() {
        _ = viewModel.getConversations().done(on: .main) { [weak self] _ in
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactTableViewCell.self)) as? ContactTableViewCell else { return UITableViewCell() }
        
        cell.updateCell(conversation: viewModel.conversations[indexPath.row])
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = ChatViewController()
        chatViewController.conversation = viewModel.conversations[indexPath.row]
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}


