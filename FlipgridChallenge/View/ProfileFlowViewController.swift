//
//  ProfileFlowViewController.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/20/21.
//

import UIKit

/// Flow view controller to manage the flow between profile screens.
class ProfileFlowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileCreationViewController = ProfileCreationViewController.createViewController(delegate: self)
        transition(to: profileCreationViewController)
    }
}

extension ProfileFlowViewController: ProfileCreationViewControllerDelegate {
    func submitTapped(profile: Profile) {
        let confirmationViewModel = ConfirmationViewModel(profile: profile)
        let confirmationViewController = ProfileConfirmationViewController.createViewController(confirmationViewModel: confirmationViewModel,
                                                                                                delegate: self)
        transition(to: confirmationViewController)
    }
}

extension ProfileFlowViewController: ProfileConfirmationViewControllerDelegate {
    func signInTapped() {
        // Out of scope:
        // Transition to Login screen
    }
}
