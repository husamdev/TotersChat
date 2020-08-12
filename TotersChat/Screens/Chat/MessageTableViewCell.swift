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
        v.layer.cornerRadius = 5
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(bubble)
        bubble.addSubview(textView)
        
        addConstraints()
    }
    
    func addConstraints() {
        let bubbleWidth = UIScreen.main.bounds.width * 0.65
        NSLayoutConstraint.activate([
            bubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
