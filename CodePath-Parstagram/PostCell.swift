//
//  PostCell.swift
//  CodePath-Parstagram
//
//  Created by Denielle Abaquita on 10/6/21.
//

import UIKit
import Parse

class PostCell: UITableViewCell {
    
    static let identifier = "PostCell"
    
    // Subview properties
    private let stackView = UIStackView()
    let postImageView = UIImageView()
    private let labelStackView = UIStackView()
    let usernameLabel = UILabel()
    let captionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure views
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 21
        contentView.addSubview(stackView)
        
        // Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -11)
        ])
        
        // Subviews
        stackView.addArrangedSubview(postImageView)
        configureNestedStackView()
    }
    
    private func configureNestedStackView() {
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillProportionally
        labelStackView.alignment = .fill
        labelStackView.spacing = 11
        stackView.addArrangedSubview(labelStackView)
        
        // Subviews
        usernameLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        usernameLabel.numberOfLines = 1
        labelStackView.addArrangedSubview(usernameLabel)
        
        captionLabel.font = .systemFont(ofSize: 16)
        captionLabel.numberOfLines = 0
        labelStackView.addArrangedSubview(captionLabel)
    }
    
    
}
