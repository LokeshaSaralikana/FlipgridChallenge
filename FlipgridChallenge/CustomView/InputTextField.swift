//
//  InputTextField.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/24/21.
//

import UIKit

class InputTextField: UITextField {

    @IBInspectable var placeholderText: String = "" {
        didSet {
            let placeholderText = NSAttributedString(string: NSLocalizedString(placeholderText, comment: ""),
                                                     attributes: [.foregroundColor: UIColor.systemGray])
            attributedPlaceholder = placeholderText
        }
    }
}
