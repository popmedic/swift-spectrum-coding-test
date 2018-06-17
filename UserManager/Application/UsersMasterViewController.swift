//
//  ViewController.swift
//  UserManager
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
    
    var users:[User]?
    
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
            // if loading the detail view for editing an existing user, set the user id in
            // the detail view controller to indicate that it is in Edit mode
            if identifier == "ShowDetailSegueToEdit" {
                if let users = self.users {
                    destination.userID = users[indexPath.row].id
                }
            } else if identifier == "ShowDetailSegueToAdd" {
                // if we are loading the detail view to create a new user, nil out the user id
                destination.userID = nil
            }
            // hide the masterview on ipads
            if UIDevice.current.userInterfaceIdiom == .pad {
                UIView.animate(withDuration: 0.5) { () -> Void in
                    self.splitViewController?.preferredDisplayMode = .primaryHidden
                }
            }
        }
    }
    
    /**
     reloads the model (users) and the table view
     */
    func reload() {
        // get all the users
        userManager.readAllUsers() { (users, error) in
            // if we got an error, show the user
            if let error = error {
                self.showAlertOk(title: "Read All Users Error", message: error.localizedDescription)
                return
            }
            // update the model
            self.users = users
        }
        // reload the table view
        self.tableView.reloadData()
    }
}

// MARK: - master view controllers implementation of table view delegete and datasource

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

// MARK: - master view controllers implementation of split view controller delegate

extension UsersMasterViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        // makes it so that on smaller devices we start with the master view controller
        return self.collapseDetailViewController
    }
}
