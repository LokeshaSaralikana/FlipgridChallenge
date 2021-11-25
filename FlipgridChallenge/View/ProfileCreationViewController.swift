//
//  ProfileCreationViewController.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/20/21.
//

import UIKit
protocol ProfileCreationViewControllerDelegate: AnyObject {
    func submitTapped(profile: Profile)
}

class ProfileCreationViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var addAvatarLabel: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var submitButton: GradientButton!

    weak var delegate: ProfileCreationViewControllerDelegate?
    private var profileViewModel = ProfileViewModel()
    private var photoPickerCoordinator: PhotoPickerCoordinator?

    static func createViewController(delegate: ProfileCreationViewControllerDelegate?) -> ProfileCreationViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: Bundle(for: Self.self))
        guard let viewController = storyboard.instantiateViewController(identifier: "ProfileCreationViewController") as? ProfileCreationViewController else {
            fatalError("\(String(describing: self)) creation failed")
        }
        viewController.delegate = delegate

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileViewModel.viewDelegate = self
        
        setupObservers()
        setupTapGestures()
        avatarImageView.layer.cornerRadius = 10.0
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        // These keyboard observers can be part of a protocol to support reusability.
        // ViewControllers that require keyboard handling can conform to the protocol and handle the notification callbacks as required.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func setupTapGestures() {

        // dismiss keyboard if anything outside editable field is tapped
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)

        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        avatarImageView.addGestureRecognizer(imageTapGesture)
        avatarImageView.isUserInteractionEnabled = true
    }

    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        photoPickerCoordinator = PhotoPickerCoordinator(baseViewController: self, delegate: self)
        photoPickerCoordinator?.start()
    }

    @IBAction func didTapSubmit(_ sender: UIButton) {
        view.endEditing(true)
        activityIndicator.startAnimating()
        profileViewModel.submitTapped(avatar: avatarImageView.image,
                                      firstName: firstNameField.text,
                                      email: emailField.text!,
                                      password: passwordField.text!,
                                      website: websiteField.text)
    }
}

// TextField notification
extension ProfileCreationViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ notification: Notification) {
        guard let activeTextField = notification.object as? UITextField else { return }

        if activeTextField == emailField {
            profileViewModel.email = activeTextField.text ?? ""
        } else if activeTextField == passwordField {
            profileViewModel.password = activeTextField.text ?? ""
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameField:
            emailField.becomeFirstResponder()
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            websiteField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }

        return false
    }
}

// Keyboard notifications
extension ProfileCreationViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        let inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height - view.safeAreaInsets.bottom, right: 0.0)
        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

extension ProfileCreationViewController: ProfileViewModelViewDelegate {
    func submitStatusDidChange(canSubmit: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.submitButton.alpha = canSubmit ? 1.0 : 0.4
        } completion: { _ in
            self.submitButton.isEnabled = canSubmit
        }
    }

    func loginHandler(profile: Profile?) {
        // TODO: Display error if the API returns failure
        // Transition to confirmation screen if the API returns success
        guard let profile = profile else {
            // show error - invalid response
            return
        }
        // Simulating the activity progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.delegate?.submitTapped(profile: profile)
        }
    }
}

extension ProfileCreationViewController: PhotoPickerCoordinatorDelegate {
    func photoSelected(image: UIImage?) {
        avatarImageView.image = image
        addAvatarLabel.isHidden = image != nil
    }
}
