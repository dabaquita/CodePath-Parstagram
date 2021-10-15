//
//  NewCommentCell.swift
//  CodePath-Parstagram
//
//  Created by Denielle Abaquita on 10/15/21.
//

import UIKit

class NewCommentCell: UITableViewCell {

    static let identifier = "NewCommentCell"
    
    let commentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        commentLabel.text = "Add new comment..."
        commentLabel.font = .systemFont(ofSize: 16)
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = .left
        commentLabel.textColor = .systemGray
        contentView.addSubview(commentLabel)
        
        // Constraints
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
            commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
