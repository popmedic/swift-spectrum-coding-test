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
    @IBOutlet weak var lettersAndDigitsValidateControl: ValidateControl!
    @IBOutlet weak var between5And12ValidateControl: ValidateControl!
    @IBOutlet weak var sameSequenceValidateControl: ValidateControl!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var updateUserButton: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var usernameValidationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adds a button to the display view for getting back
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
        
        // handle moving the buttons and scrollview when keyboard is shown
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil
        )
        
        // add a gesture recognizer for hiding the keyboard when user taps outside text field
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        // add validators to the validate controls
        self.between5And12ValidateControl.validators.append(LengthValidator(range: 5..<13))
        self.lettersAndDigitsValidateControl.validators.append(CharSetValidator(charset: CharacterSet.alphanumerics))
        self.lettersAndDigitsValidateControl.validators.append(LetterAndNumberValidator())
        self.sameSequenceValidateControl.validators.append(SequenceValidator(true))
        
        // configure the view, make the detail view blank if unable to configure
        self.view.isHidden = !configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // remove the keyboard observer
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func imageButtonAction(_ sender: Any) {
        self.endEditing()
        // show an alert to see if user want to use their galery or
        // camera to add a user image
        self.showImageAlert()
    }
    
    @IBAction func updateUserButtonAction(_ sender: Any) {
        self.endEditing()
        // update the user information
        self.userManager.updateUser(
            id: self.userID!,
            username: self.usernameTextField.text,
            password: self.passwordTextField.text,
            image: UIImagePNGRepresentation(self.imageButton.backgroundImage(for: .normal)!)
        ) { (error) in
            // on error display an alert to the user
            if let error = error {
                self.showAlertOk(title: "Update User Error", message: error.localizedDescription)
                return
            }
            // no error, reload the master view controller to show the new user
            if let usersViewController = (self.splitViewController?.viewControllers[0] as? UINavigationController)?
                .viewControllers[0] as? UsersMasterViewController {
                usersViewController.reload()
            }
        }
    }
    
    @IBAction func deleteUserButtonAction(_ sender: Any) {
        if let userID = self.userID {
            // delete the user
            self.userManager.deleteUser(id: userID) { (error) in
                // on error display an alert to the user
                if let error = error {
                    self.showAlertOk(title: "Delete User Error", message: error.localizedDescription)
                    return
                }
                // no error, reload the master view controller
                if let usersViewController = (self.splitViewController?.viewControllers[0] as? UINavigationController)?
                    .viewControllers[0] as? UsersMasterViewController {
                    usersViewController.reload()
                }
                self.view.isHidden = true
            }
        }
    }
    
    @IBAction func createUserButtonAction(_ sender: Any) {
        self.endEditing()
        // create a user
        userManager.createUser(
            username: self.usernameTextField.text!,
            password: self.passwordTextField.text!,
            image: UIImagePNGRepresentation(self.imageButton.backgroundImage(for: .normal)!)
        ) { (error) in
            // on error display an alert to the user
            if let error = error {
                self.showAlertOk(title: "Create User Error", message: error.localizedDescription)
                return
            }
            // no error, get the new userID using the username so we can turn the view
            // into an edit view with the new user set for editing
            if let username = self.usernameTextField.text {
                //
                self.userManager.readUser(username: username, completion: { (user, error) in
                    // on error display an alert to the user
                    if let error = error {
                        self.showAlertOk(title: "Update/Read User Error", message: error.localizedDescription)
                        return
                    }
                    // no error, turn the view into an edit view with the new user set for editing
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
    
    /**
     validate the password using the string in the password text field,
     and the 3 validator views.
 
     - returns:
     true if all are valid, false if anyone fails
     */
    func isValidPassword() -> Bool {
        let string = self.passwordTextField.text ?? ""
        self.lettersAndDigitsValidateControl.validate(string: string)
        self.between5And12ValidateControl.validate(string: string)
        self.sameSequenceValidateControl.validate(string: string)
        return self.lettersAndDigitsValidateControl.isValid &&
            self.between5And12ValidateControl.isValid &&
            self.sameSequenceValidateControl.isValid
    }

    /**
     validate the username using the string in the username text field,
     and the username validator, also sets the username validation label
     text to indicate why the username is invalid
     
     - returns:
     true if valid, false if invalid
     */
    func isValidUsername() -> Bool {
        let text = usernameTextField.text ?? ""
        // make sure the username has some characters
        guard text.count > 0 else {
            self.usernameValidationLabel.text = "username must be filled out"
            return false
        }
        // make sure it does not already exist
        if !UsernameValidator(userManager: self.userManager).isValid(string: text) {
            self.usernameValidationLabel.text = "username already exists"
            return false
        }
        // if it is valid clear out the indicator text
        self.usernameValidationLabel.text = ""
        return true
    }
    /**
     handle when the username or password text field change by validating
     the text field
     */
    @objc func textFieldDidChange() {
        let validPassword = self.isValidPassword()
        // not allowing username edits right now, so only validate the
        // if configured for create
        var validUsername = true
        if !self.isEdit {
            validUsername = self.isValidUsername()
        }
        self.buttonEnabled = validPassword && validUsername
    }
    /**
     handle end editing to hide keyboard
     */
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    /**
     handle showing/hiding of the keyboard by adjusting the bottom
     constraints to the height of the keyboard
     */
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            // compute keyboard frame size and set up animation
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
            // trigger the animation
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                                self.view.layoutIfNeeded()
                           },
                           completion: nil)
        }
    }
}

// MARK: - detail view controllers implementation for image picking

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
    
    /**
     shows an alert (action sheet on iphone/alert on ipad) so user can select to
     get the image from the gallery or from the camera
     */
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
            return self.isEdit ? self.updateUserButton.isEnabled : self.createUserButton.isEnabled
        }
        set(value) {
            let userButton:UIButton!
            if self.isEdit {
                userButton = self.updateUserButton
            } else {
                userButton = self.createUserButton
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
            return configureCreateView()
        }
    }
    private func configureCreateView() -> Bool {
        self.navigationItem.title = "Create User"
        
        self.updateUserButton.isHidden = true
        self.deleteUserButton.isHidden = true
        self.createUserButton.isHidden = false
        
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
        self.createUserButton.isHidden = true
        
        self.passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        self.usernameTextField.isEnabled = false
        
        return success
    }
}
