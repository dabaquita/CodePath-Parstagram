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
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
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
        query.includeKeys(["author", "comments", "comments.author"])
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: PostCell.identifier,
                    for: indexPath
            ) as? PostCell else {
                print("Could not load PostCell")
                return UITableViewCell()
            }
            
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
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentCell.identifier,
                    for: indexPath
            ) as? CommentCell else {
                print("Could not load CommentCell")
                return UITableViewCell()
            }
            
            guard let comments = post["comments"] as? [PFObject] else {
                return UITableViewCell()
            }
            
            let comment = comments[indexPath.row - 1]

            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username

            cell.commentLabel.text = comment["text"] as! String
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.bounds.height / 1.5
        } else {
            return view.bounds.height / 13
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        let comment = PFObject(className: "Comments")
        comment["text"] = "This is a random comment"
        comment["post"] = post
        comment["author"] = PFUser.current()!
        
        post.add(comment, forKey: "comments")
        post.saveInBackground { (success, error) in
            if success {
                print("Comment saved")
            } else {
                print("Failed to get post due to \(error?.localizedDescription)")
            }
        }
    }
}
