//
//  ProfileConfirmationViewController.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/21/21.
//

import UIKit

protocol ProfileConfirmationViewControllerDelegate: AnyObject {
    func signInTapped()
}

class ProfileConfirmationViewController: UIViewController, ViewModelViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var websiteTextView: UITextView! // Using UITextView object since it has native support for links
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signInButton: GradientButton!

    weak var delegate: ProfileConfirmationViewControllerDelegate?

    var viewModel: ConfirmationViewModel!
    static var storyboardName: String = "Profile"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        avatarImageView.layer.cornerRadius = 10.0

        helloLabel.text = viewModel.helloUserText
        avatarImageView.image = viewModel.avatarImage
        websiteTextView.text = viewModel.websiteText
        // As an improvement, we could use attributed text for website field.
        // Also, currently there's not enough validation on the profile creation screen for fields other than email and password.
        websiteTextView.linkTextAttributes = [.underlineStyle: 1, .underlineColor: UIColor.systemBlue]
        firstNameLabel.text = viewModel.firstName
        emailLabel.text = viewModel.email

        websiteTextView.isHidden = viewModel.isWebsiteEmpty
        firstNameLabel.isHidden = viewModel.isFirstNameEmpty
    }

    @IBAction func didTapSignIn(_ sender: UIButton) {
        // TODO: out of scope
        delegate?.signInTapped()
    }
}
