//
//  UserViewController.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/13/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

class DetailedUserViewController: UIViewController {
    let userManager = (UIApplication.shared.delegate as! AppDelegate).userManager
    
    @IBOutlet weak var bottomConstrant: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var updateUserButton: UIButton!
    
    var userID:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
        
        if let userID = self.userID {
            var success = false
            self.userManager.readUser(id: userID, completion: { (user, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let user = user {
                    success = true
                    self.usernameTextField.text = user.username
                    self.passwordTextField.text = user.password
                    self.userImageView.image = UIImage(data: user.image)
                }
            })
            if success {
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(self.keyboardNotification(notification:)),
                    name: NSNotification.Name.UIKeyboardWillChangeFrame,
                    object: nil
                )

                self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
                return
            }
        }
        
        self.view.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateUserButtonAction(_ sender: Any) {
    }
    
    @IBAction func deleteUserButtonAction(_ sender: Any) {
        if let userID = self.userID {
            self.userManager.deleteUser(id: userID) { (error) in
                if let error = error {
                    print(error)
                    return
                }
                if let usersViewController = (self.splitViewController?.viewControllers[0] as? UINavigationController)?
                    .viewControllers[0] as? UsersViewController {
                    usersViewController.reload()
                }
                self.view.isHidden = true
            }
        }
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.bottomConstrant.constant = 0.0
            } else {
                self.bottomConstrant.constant = (endFrame?.size.height ?? 0.0) * -1.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
