//
//  ContactTableViewCell.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/11/20.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    var contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = .white
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Husam"
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.text = "Hello! How are you doing?"
        return label
    }()
    
    var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(contactImageView)
        contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(messageLabel)
        
        constraintViews()
    }
    
    func constraintViews() {
        NSLayoutConstraint.activate([
            contactImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contactImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contactImageView.heightAnchor.constraint(equalToConstant: 50),
            contactImageView.widthAnchor.constraint(equalToConstant: 50),
            
            verticalStackView.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 15),
            verticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        contentView.layoutIfNeeded()
    }
    
    func updateCell() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
