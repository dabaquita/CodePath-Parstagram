//
//  FeedViewController.swift
//  CodePath-Parstagram
//
//  Created by Denielle Abaquita on 10/6/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController {
    
    let tableView = UITableView()
    var posts = [PFObject]()
    private let customRefreshControl = UIRefreshControl()
    private let userLoggedInKey = "userLoggedIn"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Configure nav bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "insta_camera_btn"),
            style: .plain,
            target: self,
            action: #selector(didTapCamera(_:))
        )
        let logoImageView = UIImageView(image: UIImage(named: "instagram_logo"))
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
        
        customRefreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = customRefreshControl
        
        // Configure any subviews
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadPosts(self)
    }
    
    // MARK: Configure Subviews
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        view.addSubview(tableView)
        
        // Constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Selectors
    @objc func didTapCamera(_ sender: Any) {
        let cameraVC = CameraViewController()
        self.show(cameraVC, sender: self)
    }
    
    @objc func didTapLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if let error = error {
                print("Error in logging out due to \(error)")
            } else {
                UserDefaults.standard.setValue(false, forKey: self.userLoggedInKey)
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func loadPosts(_ sender: Any) {
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
                self.customRefreshControl.endRefreshing()
            } else {
                print("Could not find posts due to \(error?.localizedDescription)")
            }
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PostCell.identifier,
                for: indexPath
        ) as? PostCell else {
            print("Could not load PostCell")
            return UITableViewCell()
        }
        let post = posts[indexPath.row]
        
        if let user = post["author"] as? PFUser {
            cell.usernameLabel.text = user.username
        } else {
            cell.usernameLabel.text = "ERROR: NOT FOUND"
        }
        
        if let caption = post["caption"] as? String {
            cell.captionLabel.text = caption
        }
        
        if let imageFile = post["image"] as? PFFileObject,
           let urlString = imageFile.url,
           let url = URL(string: urlString) {
            cell.postImageView.af.setImage(withURL: url)
        } else {
            cell.postImageView.image = UIImage(named: "image_placeholder")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 1.3
    }
}
