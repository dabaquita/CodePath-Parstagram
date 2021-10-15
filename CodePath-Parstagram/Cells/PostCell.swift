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
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 21
        contentView.addSubview(stackView)
        
        // Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -21)
        ])
        
        // Subviews
        stackView.addArrangedSubview(postImageView)
        
        configureNestedStackView()
    }
    
    private func configureNestedStackView() {
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillProportionally
        labelStackView.alignment = .fill
        labelStackView.spacing = 21
        stackView.addArrangedSubview(labelStackView)
        
        // Subviews
        usernameLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        usernameLabel.numberOfLines = 1
        usernameLabel.textAlignment = .left
        usernameLabel.setContentHuggingPriority(.required, for: .horizontal)
        usernameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        labelStackView.addArrangedSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: 11)
        ])
        
        captionLabel.font = .systemFont(ofSize: 16)
        captionLabel.numberOfLines = 0
        captionLabel.textAlignment = .left
        labelStackView.addArrangedSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            captionLabel.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor, constant: -11)
        ])
    }
}
