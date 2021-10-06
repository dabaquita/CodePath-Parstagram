//
//  ViewController.swift
//  CodePath-Parstagram
//
//  Created by Denielle Abaquita on 10/2/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    let mainVerticalStackView = UIStackView()
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        if let logo = UIImage(named: "instagram_logo") {
            imageView.image = logo
        } else {
            imageView.image = UIImage(systemName: "person")
        }
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    let usernameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    let passwordTextfield: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    let buttonHorizStackView = UIStackView()
    let signInButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Sign In", for: .normal)
        return button
    }()
    let signUpButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Sign Up", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        
        configureMainVerticalStackView()
    }
    
    // MARK: Configure Subviews
    private func configureMainVerticalStackView() {
        mainVerticalStackView.axis = .vertical
        mainVerticalStackView.distribution = .fillProportionally
        mainVerticalStackView.alignment = .fill
        mainVerticalStackView.spacing = 11
        view.addSubview(mainVerticalStackView)
        
        // Constraints
        mainVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainVerticalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 7),
            mainVerticalStackView.heightAnchor.constraint(equalToConstant: view.bounds.height / 2),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        
        // Adding arranged subviews
        mainVerticalStackView.addArrangedSubview(logoImageView)
        mainVerticalStackView.addArrangedSubview(usernameLabel)
        mainVerticalStackView.addArrangedSubview(usernameTextfield)
        mainVerticalStackView.addArrangedSubview(passwordLabel)
        mainVerticalStackView.addArrangedSubview(passwordTextfield)
        configureButtonStackView()
    }
    
    private func configureButtonStackView() {
        buttonHorizStackView.axis = .horizontal
        buttonHorizStackView.distribution = .fillProportionally
        buttonHorizStackView.alignment = .center
        buttonHorizStackView.spacing = 11
        
        // Sign In
        signInButton.addTarget(
            self,
            action: #selector(didTapSignIn(_:)),
            for: .touchUpInside
        )
        buttonHorizStackView.addArrangedSubview(signInButton)
        
        // Sign Up
        signUpButton.addTarget(
            self,
            action: #selector(didTapSignUp(_:)),
            for: .touchUpInside
        )
        buttonHorizStackView.addArrangedSubview(signUpButton)
        
        mainVerticalStackView.addArrangedSubview(buttonHorizStackView)
    }
    
    // MARK: Selectors
    @objc func didTapSignIn(_ sender: Any) {
        print("Tapped Sign In")
    }
    
    @objc func didTapSignUp(_ sender: Any) {
        print("Tapped Sign Up")
    }
}

