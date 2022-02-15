//
//  TextChatCell.swift
//  TotersChatUI
//
//  Created by Husam Dayya on 14/02/2022.
//

import UIKit

class TextChatCell: UITableViewCell {
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var textLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textTrailingConstraint: NSLayoutConstraint!
    
    func configure(using viewModel: TextChatViewModel) {
        labelText.text = viewModel.text
        textLeadingConstraint.isActive = !viewModel.isSent
        textTrailingConstraint.isActive = viewModel.isSent
        
        labelText.layer.cornerRadius = 10
        labelText.backgroundColor = viewModel.isSent ? .totersGreen : .lightGray
        labelText.textColor = viewModel.isSent ? .white : .black
    }
}

extension UIColor {
    static var totersGreen = UIColor(red: 54/250, green: 180/250, blue: 170/250, alpha: 1)
}
