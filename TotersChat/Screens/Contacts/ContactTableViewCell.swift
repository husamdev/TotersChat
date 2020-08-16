//
//  ContactTableViewCell.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/11/20.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    var contactImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 25
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    var nameLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = .systemFont(ofSize: 16)
        return l
    }()
    
    var messageLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        l.font = .systemFont(ofSize: 12)
        l.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return l
    }()
    
    var dateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .gray
        l.font = .systemFont(ofSize: 12)
        l.textAlignment = .right
        l.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return l
    }()
    
    var horizontalStackView: UIStackView = {
       let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 5
        return s
    }()
    
    var verticalStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.translatesAutoresizingMaskIntoConstraints = false
        s.distribution = .fillEqually
        return s
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(contactImageView)
        contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(messageLabel)
        horizontalStackView.addArrangedSubview(dateLabel)
        
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
    
    func updateCell(conversation: Conversation) {
        nameLabel.text = conversation.contact.name
        contactImageView.image = UIImage(named: conversation.contact.image)
        
        if let lastMessage = conversation.lastMessage {
            horizontalStackView.isHidden = false
            
            messageLabel.text = lastMessage.text
            dateLabel.text = lastMessage.date.getNiceDateFormat()
        } else {
            horizontalStackView.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        contactImageView.image = nil
    }
    
}
