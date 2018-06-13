//
//  AddUserViewController.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {
    private let checkedString = "✅"
    private let exedString = "❌"
    private let userPersist = (UIApplication.shared.delegate as! AppDelegate).userPersist
    private var addUserButtonEnabled:Bool {
        get {
            return self.addUserButton.isEnabled
        }
        set(value) {
            self.addUserButton.isEnabled = value
            if self.addUserButton.isEnabled {
                self.addUserButton.backgroundColor = UIColor(red: 0.0, green: 111.0/255.0, blue: 1, alpha: 1)
            } else {
                self.addUserButton.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @IBOutlet weak var bottomConstrant: NSLayoutConstraint!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameValidationLabel: UILabel!
    @IBOutlet weak var lettersAndDigitsValidationLabel: UILabel!
    @IBOutlet weak var between5And12ValidationLabel: UILabel!
    @IBOutlet weak var sequenceValidationLabel: UILabel!
    @IBOutlet weak var addUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil
        )
        
        self.passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        self.usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        self.textFieldDidChange()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UsersViewController {
            destination.reload()
        }
    }
    
    @IBAction func addUserButtonAction(_ sender: Any) {
        userPersist.createUser(
            username: self.usernameTextField.text!,
            password: self.passwordTextField.text!,
            image: nil
        ) { (error) in
            if let error = error {
                print(error)
                return
            }
            self.performSegue(withIdentifier: "unwindSegueToUsersViewController", sender: self)
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
    
    @objc func textFieldDidChange() {
        let validPassword = self.isValidPassword()
        let validUsername = self.isValidUsername()
        self.addUserButtonEnabled = validPassword && validUsername
    }
    
    func isValidPassword() -> Bool {
        let text = passwordTextField.text ?? ""
        if LengthValidator.init(range: 5..<13).isValid(string: text) {
            self.between5And12ValidationLabel.text = self.checkedString
        } else {
            self.between5And12ValidationLabel.text = self.exedString
        }
        
        if CharSetValidator(charset: CharacterSet.alphanumerics).isValid(string: text) &&
            LetterAndNumberValidator().isValid(string: text) {
            self.lettersAndDigitsValidationLabel.text = self.checkedString
        } else {
            self.lettersAndDigitsValidationLabel.text = self.exedString
        }
        
        return self.lettersAndDigitsValidationLabel.text == self.checkedString &&
               self.between5And12ValidationLabel.text == self.checkedString &&
               self.sequenceValidationLabel.text == self.checkedString
    }
    
    func isValidUsername() -> Bool {
        let text = usernameTextField.text ?? ""
        guard text.count > 0 else {
            self.usernameValidationLabel.text = "username must be filled out"
            return false
        }
        if !UsernameValidator(userPersist: self.userPersist).isValid(string: text) {
            self.usernameValidationLabel.text = "username already exists"
            return false
        }
        self.usernameValidationLabel.text = ""
        return true
    }
}
