//
//  ChatViewController.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import UIKit

class ChatViewController: UIViewController {
    
    var messages: [Message] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = self.view.frame
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: String(describing: MessageTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        title = "Husam"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(tableView)
        view.backgroundColor = .myBlack
        
        tableView.dataSource = self
        tableView.reloadData()        
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:
            MessageTableViewCell.self)) as? MessageTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
