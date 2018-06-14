//
//  ViewController.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

class UsersMasterViewController: UIViewController {
    private var collapseDetailViewController = true
    
    let CellIdentifier = "UsersTableViewCell"
    let userManager = (UIApplication.shared.delegate as! AppDelegate).userManager
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindToUsersViewController(segue:UIStoryboardSegue) { }
    
    var users:[SCTUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.splitViewController?.delegate = self
        self.splitViewController?.presentsWithGesture = true
        self.reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = (segue.destination as? UINavigationController)?.visibleViewController as? UsersDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow,
           let identifier = segue.identifier {
            if identifier == "ShowDetailSegueToEdit" {
                if let users = self.users {
                    destination.userID = users[indexPath.row].id
                }
            } else if identifier == "ShowDetailSegueToAdd" {
                destination.userID = nil
            }
        }
    }
    
    func reload() {
        userManager.readAllUsers() { (users, error) in
            if let error = error {
                self.showAlertOk(title: "Read All Users Error", message: error.localizedDescription)
                return
            }
            self.users = users
        }
        self.tableView.reloadData()
        self.collapseDetailViewController = true
    }
}

extension UsersMasterViewController:  UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        collapseDetailViewController = false
    }
}

extension UsersMasterViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        return self.collapseDetailViewController
    }
}
