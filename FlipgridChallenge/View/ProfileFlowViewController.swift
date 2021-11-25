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

        let profileViewModel = ProfileViewModel()
        let profileCreationViewController = ProfileCreationViewController.viewController(viewModel: profileViewModel)
        profileCreationViewController.delegate = self
        transition(to: profileCreationViewController)
    }
}

extension ProfileFlowViewController: ProfileCreationViewControllerDelegate {
    func submitTapped(profile: Profile) {
        let confirmationViewModel = ConfirmationViewModel(profile: profile)
        let confirmationViewController = ProfileConfirmationViewController.viewController(viewModel: confirmationViewModel)
        confirmationViewController.delegate = self
        transition(to: confirmationViewController)
    }
}

extension ProfileFlowViewController: ProfileConfirmationViewControllerDelegate {
    func signInTapped() {
        // Out of scope:
        // Transition to Login screen
    }
}
