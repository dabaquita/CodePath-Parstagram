//
//  FeedViewController.swift
//  CodePath-Parstagram
//
//  Created by Denielle Abaquita on 10/6/21.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController {
    
    let tableView = UITableView()
    let commentBar = MessageInputBar()
    
    var posts = [PFObject]()
    private let customRefreshControl = UIRefreshControl()
    private let userLoggedInKey = "userLoggedIn"
    private var showsCommentBar = false
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }

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
        
        // Notification center
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Configure any subviews
        commentBar.inputTextView.placeholder = "Add new comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadPosts(self)
    }
    
    // Configure subviews
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.register(NewCommentCell.self, forCellReuseIdentifier: NewCommentCell.identifier)
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
    
    // Selectors
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
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
}

// MARK: TableViewDelegate & DataSource
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
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
            
            cell.isUserInteractionEnabled = false
            return cell
        } else if indexPath.row <= comments.count {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentCell.identifier,
                    for: indexPath
            ) as? CommentCell else {
                print("Could not load CommentCell")
                return UITableViewCell()
            }
            
            let comment = comments[indexPath.row - 1]

            if let user = comment["author"] as? PFUser {
                cell.nameLabel.text = user.username
            } else {
                cell.nameLabel.text = "Error: User not found"
            }
            
            if let commentText = comment["text"] as? String {
                cell.commentLabel.text = commentText
            } else {
                cell.commentLabel.text = "Error: Comment not found"
            }
            
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewCommentCell.identifier,
                    for: indexPath
            ) as? NewCommentCell else {
                print("Could not load NewCommentCell")
                return UITableViewCell()
            }
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
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
    }
}

// MARK: MessageInputBarDelegate
extension FeedViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Create comment
        
        // Clear and dismiss input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
}
