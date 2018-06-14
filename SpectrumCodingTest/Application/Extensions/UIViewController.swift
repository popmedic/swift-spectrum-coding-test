//
//  UIViewController.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/14/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertOk(title:String?, message:String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Ok",
                style: .cancel,
                handler: nil
            )
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}
