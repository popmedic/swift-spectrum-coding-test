//
//  ViewController.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let CellIdentifier = "UsersTableViewCell"
    let userPersist = (UIApplication.shared.delegate as! AppDelegate).userPersist
    var users:[SCTUser]? = nil
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToUsersViewController(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        userPersist.readAllUsers() { (users, error) in
            if let error = error {
                print(error)
                return
            }
            self.users = users
        }
        self.tableView.reloadData()
    }
}

extension UsersViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users == nil ? 0 : users!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier) as? UsersTableViewCell {
            if let users = self.users {
                cell.userImageView.image = UIImage(data: users[indexPath.row].image)
                cell.userNameLabel.text = users[indexPath.row].username
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
}

