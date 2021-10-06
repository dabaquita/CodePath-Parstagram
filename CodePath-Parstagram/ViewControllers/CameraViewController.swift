//
//  CameraViewController.swift
//  CodePath-Parstagram
//
//  Created by Denielle Abaquita on 10/6/21.
//

import UIKit

class CameraViewController: UIViewController {
    
    let mainVerticalStackView = UIStackView()
    let postImageView = UIImageView()
    let commentTextField = UITextField()
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapSubmit(_:)),
            for: .touchUpInside
        )
        button.clipsToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureStackView()
    }
    
    // MARK: Configure Subviews
    private func configureStackView() {
        mainVerticalStackView.axis = .vertical
        mainVerticalStackView.distribution = .fillProportionally
        mainVerticalStackView.alignment = .fill
        mainVerticalStackView.spacing = 21
        view.addSubview(mainVerticalStackView)
        
        // Constraints
        mainVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainVerticalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 11),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -11),
            mainVerticalStackView.heightAnchor.constraint(equalToConstant: view.bounds.height / 2)
        ])
        
        // Arranged subviews
        configurePostImageView()
        configureCommentTextField()
        mainVerticalStackView.addArrangedSubview(submitButton)
    }
    
    private func configurePostImageView() {
        postImageView.image = UIImage(named: "image_placeholder")
        postImageView.contentMode = .scaleAspectFit
        postImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCameraImageView(_:)))
        postImageView.addGestureRecognizer(tapGesture)
        mainVerticalStackView.addArrangedSubview(postImageView)
    }
    
    private func configureCommentTextField() {
        commentTextField.placeholder = "Comment..."
        commentTextField.borderStyle = .roundedRect
        mainVerticalStackView.addArrangedSubview(commentTextField)
    }
    
    
    // MARK: Selectors
    @objc func didTapSubmit(_ sender: Any) {
        print("Tapped submit")
    }
    
    @objc func didTapCameraImageView(_ sender: Any) {
        print("Tapped camera")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        self.present(picker, animated: true)
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
