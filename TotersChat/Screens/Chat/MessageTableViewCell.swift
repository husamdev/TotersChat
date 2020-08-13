//
//  MessageTableViewCell.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    var bubble: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.cornerRadius = 20
        v.backgroundColor = .mylightBlack
        return v
    }()
    
    var textView: UITextView = {
        let t = UITextView()
        t.textAlignment = .natural
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = .clear
        t.font = .systemFont(ofSize: 15)
        t.textColor = .white
        t.isScrollEnabled = false
        t.isEditable = false
        return t
    }()
    
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.backgroundColor = .darkGray
        iv.layer.cornerRadius = 15
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(bubble)
        bubble.addSubview(textView)
        
        addConstraints()
    }
    
    fileprivate func addProfileImageView() {
        contentView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        contentView.layoutIfNeeded()
    }
    
    func updateCell(isSend: Bool) {
        setupUI()
        
        if isSend {
            bubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
            bubble.backgroundColor = .myGreen
        } else {
            bubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
            bubble.backgroundColor = .mylightBlack
            addProfileImageView()
        }
        
        contentView.layoutIfNeeded()
    }
    
    func addConstraints() {
        let bubbleWidth = UIScreen.main.bounds.width * 0.65
        NSLayoutConstraint.activate([
            bubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            bubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            bubble.widthAnchor.constraint(lessThanOrEqualToConstant: bubbleWidth),
            
            textView.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 5),
            textView.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -5),
            textView.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 5),
            textView.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -5)
        ])
        
        contentView.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        bubble.backgroundColor = nil
        profileImageView.removeFromSuperview()
        textView.removeFromSuperview()
        bubble.removeFromSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
