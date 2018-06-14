//
//  UserViewController.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/13/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {
    private let userManager = (UIApplication.shared.delegate as! AppDelegate).userManager
    
    var userID:Any?
    
    @IBOutlet var bottomConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var lettersAndDigitsValidateView: ValidateView!
    @IBOutlet weak var between5And12ValidateView: ValidateView!
    @IBOutlet weak var sameSequenceValidateView: ValidateView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var updateUserButton: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    @IBOutlet weak var addUserButton: UIButton!
    @IBOutlet weak var usernameValidationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil
        )
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        self.between5And12ValidateView.validators.append(LengthValidator.init(range: 5..<13))
        self.lettersAndDigitsValidateView.validators.append(CharSetValidator(charset: CharacterSet.alphanumerics))
        self.lettersAndDigitsValidateView.validators.append(LetterAndNumberValidator())
        self.sameSequenceValidateView.validators.append(SequenceValidator(true))
        
        self.view.isHidden = !configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageButtonAction(_ sender: Any) {
        self.endEditing()
        self.showImageAlert()
    }
    
    @IBAction func updateUserButtonAction(_ sender: Any) {
        self.endEditing()
        
        self.userManager.updateUser(
            id: self.userID!,
            username: self.usernameTextField.text,
            password: self.passwordTextField.text,
            image: UIImagePNGRepresentation(self.imageButton.backgroundImage(for: .normal)!)
        ) { (error) in
            if let error = error {
                self.showAlertOk(title: "Update User Error", message: error.localizedDescription)
                return
            }
            if let usersViewController = (self.splitViewController?.viewControllers[0] as? UINavigationController)?
                .viewControllers[0] as? UsersMasterViewController {
                usersViewController.reload()
            }
        }
    }
    
    @IBAction func deleteUserButtonAction(_ sender: Any) {
        if let userID = self.userID {
            self.userManager.deleteUser(id: userID) { (error) in
                if let error = error {
                    self.showAlertOk(title: "Delete User Error", message: error.localizedDescription)
                    return
                }
                if let usersViewController = (self.splitViewController?.viewControllers[0] as? UINavigationController)?
                    .viewControllers[0] as? UsersMasterViewController {
                    usersViewController.reload()
                }
                self.view.isHidden = true
            }
        }
    }
    
    @IBAction func addUserButtonAction(_ sender: Any) {
        self.endEditing()
        
        userManager.createUser(
            username: self.usernameTextField.text!,
            password: self.passwordTextField.text!,
            image: UIImagePNGRepresentation(self.imageButton.backgroundImage(for: .normal)!)
        ) { (error) in
            if let error = error {
                self.showAlertOk(title: "Create User Error", message: error.localizedDescription)
                return
            }
            if let username = self.usernameTextField.text {
                self.userManager.readUser(username: username, completion: { (user, error) in
                    if let error = error {
                        self.showAlertOk(title: "Update/Read User Error", message: error.localizedDescription)
                        return
                    }
                    if let usersViewController = (self.splitViewController?.viewControllers[0] as? UINavigationController)?
                        .viewControllers[0] as? UsersMasterViewController {
                        usersViewController.reload()
                    }
                    if let user = user {
                        self.userID = user.id
                        self.view.isHidden = !self.configureView()
                    }
                })
            }
        }
    }
    
    func isValidPassword() -> Bool {
        let string = self.passwordTextField.text ?? ""
        self.lettersAndDigitsValidateView.validate(string: string)
        self.between5And12ValidateView.validate(string: string)
        self.sameSequenceValidateView.validate(string: string)
        return self.lettersAndDigitsValidateView.isValid &&
            self.between5And12ValidateView.isValid &&
            self.sameSequenceValidateView.isValid
    }

    func isValidUsername() -> Bool {
        let text = usernameTextField.text ?? ""
        guard text.count > 0 else {
            self.usernameValidationLabel.text = "username must be filled out"
            return false
        }
        if !UsernameValidator(userPersist: self.userManager).isValid(string: text) {
            self.usernameValidationLabel.text = "username already exists"
            return false
        }
        self.usernameValidationLabel.text = ""
        return true
    }
    
    @objc func textFieldDidChange() {
        let validPassword = self.isValidPassword()
        var validUsername = true
        if !self.isEdit {
            validUsername = self.isValidUsername()
        }
        self.buttonEnabled = validPassword && validUsername
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
                for constraint in self.bottomConstraints {
                    constraint.constant = 0.0
                }
            } else {
                for constraint in self.bottomConstraints {
                    constraint.constant = (endFrame?.size.height ?? 0.0) * -1.0
                }
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

// MARK: - Camera and Galery

extension UsersDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageButton.setBackgroundImage(image, for: .normal)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func showImageAlert() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIDevice().userInterfaceIdiom == .pad ? .alert : .actionSheet
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Camera",
                style: .default,
                handler: { (alert:UIAlertAction!) -> Void in
                    if UIImagePickerController.isSourceTypeAvailable(.camera){
                        let pickerController = UIImagePickerController()
                        pickerController.delegate = self;
                        pickerController.sourceType = .camera
                        self.present(pickerController, animated: true, completion: nil)
                    }
            }
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Gallery",
                style: .default,
                handler: { (alert:UIAlertAction!) -> Void in
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                        let myPickerController = UIImagePickerController()
                        myPickerController.delegate = self;
                        myPickerController.sourceType = .photoLibrary
                        self.present(myPickerController, animated: true, completion: nil)
                    }
            }
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}



// MARK: - View configuration for Create user to Edit user

extension UsersDetailViewController {
    private var buttonEnabled:Bool {
        get {
            return self.updateUserButton.isEnabled
        }
        set(value) {
            let userButton:UIButton!
            if self.isEdit {
                userButton = self.updateUserButton
            } else {
                userButton = self.addUserButton
            }
            userButton.isEnabled = value
            if value {
                userButton.backgroundColor = UIColor(red: 0.0, green: 111.0/255.0, blue: 1, alpha: 1)
            } else {
                userButton.backgroundColor = UIColor.lightGray
            }
        }
    }
    private var isEdit:Bool {
        get {
            return userID != nil
        }
    }
    private func configureView() -> Bool {
        if let userID = self.userID {
            return configureEditView(userID:userID)
        } else {
            return configureAddView()
        }
    }
    private func configureAddView() -> Bool {
        self.navigationItem.title = "Create User"
        
        self.updateUserButton.isHidden = true
        self.deleteUserButton.isHidden = true
        self.addUserButton.isHidden = false
        
        self.usernameTextField.isEnabled = true
        self.usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
        self.passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
        self.imageButton.setBackgroundImage(UIImage(named:"DefaultUserImage"), for: .normal)
        
        self.textFieldDidChange()
        
        return true
    }
    private func configureEditView(userID:Any) -> Bool {
        var success = true
        self.userManager.readUser(id: userID, completion: { (user, error) in
            if let error = error {
                self.showAlertOk(title: "Read User By Username Error", message: error.localizedDescription)
                success = false
            }
            if let user = user {
                self.navigationItem.title = "Edit \(user.username)"
                self.usernameTextField.text = user.username
                self.passwordTextField.text = user.password
                self.imageButton.setBackgroundImage(UIImage(data: user.image), for: .normal)
            }
        })
        self.updateUserButton.isHidden = false
        self.deleteUserButton.isHidden = false
        self.addUserButton.isHidden = true
        
        self.passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        self.usernameTextField.isEnabled = false
        
        return success
    }
}
