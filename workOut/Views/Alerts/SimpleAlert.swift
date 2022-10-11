//
//  SimpleAlert.swift
//  workOut
//
//  Created by Dmytro Vasylenko on 27.09.2022.
//

import UIKit

extension UIViewController {
    
    func alertOK(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
    
}
