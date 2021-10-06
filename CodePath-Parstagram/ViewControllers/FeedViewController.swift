//
//  FeedViewController.swift
//  CodePath-Parstagram
//
//  Created by Denielle Abaquita on 10/6/21.
//

import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Configure nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "insta_camera_btn"),
            style: .plain,
            target: self,
            action: #selector(didTapCamera(_:))
        )
        let logoImageView = UIImageView(image: UIImage(named: "instagram_logo"))
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
    }
    
    // MARK: Selectors
    @objc func didTapCamera(_ sender: Any) {
        print("Tapped Camera")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
