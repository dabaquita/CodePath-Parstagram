//
//  CommentCell.swift
//  CodePath-Parstagram
//
//  Created by Denielle Abaquita on 10/14/21.
//

import UIKit

class CommentCell: UITableViewCell {
    
    static let identifier = "CommentCell"
    
    let stackView = UIStackView()
    let nameLabel = UILabel()
    let commentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView() {
        // Stack View setup
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 21
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Stack View subviews
        nameLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .left
        nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.addArrangedSubview(nameLabel)
        
        commentLabel.font = .systemFont(ofSize: 16)
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = .left
        stackView.addArrangedSubview(commentLabel)
    }
}
