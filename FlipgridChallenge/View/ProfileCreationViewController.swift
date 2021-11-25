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

class ProfileCreationViewController: UIViewController, ViewModelViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var addAvatarLabel: UILabel!
    @IBOutlet weak var firstNameField: InputTextField!
    @IBOutlet weak var emailField: InputTextField!
    @IBOutlet weak var passwordField: InputTextField!
    @IBOutlet weak var websiteField: InputTextField!
    @IBOutlet weak var submitButton: GradientButton!

    weak var delegate: ProfileCreationViewControllerDelegate?
    private var photoPickerCoordinator: PhotoPickerCoordinator?

    var viewModel: ProfileViewModel!
    static var storyboardName: String = "Profile"

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDelegate = self
        
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
        viewModel.submitTapped(avatar: avatarImageView.image,
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
            viewModel.email = activeTextField.text ?? ""
        } else if activeTextField == passwordField {
            viewModel.password = activeTextField.text ?? ""
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
        // Out of scope: Display error if the API returns failure
        // Transition to confirmation screen if the API returns success
        guard let profile = profile else {
            // show error - invalid response
            return
        }
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.delegate?.submitTapped(profile: profile)
        }
    }
}

extension ProfileCreationViewController: PhotoPickerCoordinatorDelegate {
    func photoSelected(image: UIImage?) {
        avatarImageView.image = image
        addAvatarLabel.isHidden = image != nil
    }
}
