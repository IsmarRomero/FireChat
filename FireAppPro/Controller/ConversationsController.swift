//
//  ConversationsController.swift
//  FireAppPro
//
//  Created by Ismar Arilson Romero Deleon on 4/23/20.
//  Copyright © 2020 Ismar Arilson Romero Deleon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifer = "ConversationCell"

class ConversationsController: UIViewController {
    // MARK: Properties
    private let tableView = UITableView()
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
    }
    // MARK: Selector
    @objc private func showProfile() {
        logout()
    }
    
    // MARK: API
    
    private func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    private func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        } else {
            print("DEBUG: User is loggin")
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch let error {
            print("DEBUG: Error signint out")
        }
    }
    
    // MARK: Helpers
    private func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureTableView()
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain,
                                                           target: self, action: #selector(showProfile))
        
    }
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer )
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [
            .foregroundColor : UIColor.white,
        ]
        appearance.backgroundColor = .systemPurple
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Mensajes"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
}
extension ConversationsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        cell.textLabel?.text = "CEll text"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
