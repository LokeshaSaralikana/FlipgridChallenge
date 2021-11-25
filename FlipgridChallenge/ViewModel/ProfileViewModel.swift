//
//  ProfileViewModel.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/20/21.
//

import UIKit

protocol ProfileViewModelViewDelegate: AnyObject {
    func submitStatusDidChange(canSubmit: Bool)
    func loginHandler(profile: Profile?)
}

class ProfileViewModel {
    weak var viewDelegate: ProfileViewModelViewDelegate?

    let networkService: NetworkServiceProtocol

    // Injecting here helps in testing the network layer
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    // Out of scope - Keep a network service property to be used to invoke profile submit endpoint.

    // Model that is used to store the input data and will be used in submit(POST) API.
    var profile: Profile!

    var isEmailValid = false
    var isPasswordValid = false

    var canSubmit: Bool {
        return isEmailValid && isPasswordValid
    }

    var email: String = "" {
        didSet {
            guard oldValue != email else {
                return
            }
            let previousStatus = canSubmit
            isEmailValid = validateEmailFormat(email)
            if previousStatus != canSubmit {
                viewDelegate?.submitStatusDidChange(canSubmit: canSubmit)
            }
        }
    }

    var password: String = "" {
        didSet {
            guard oldValue != password else {
                return
            }
            let previousStatus = canSubmit
            isPasswordValid = validatePassword(password)
            if previousStatus != canSubmit {
                viewDelegate?.submitStatusDidChange(canSubmit: canSubmit)
            }
        }
    }

    func validateEmailFormat(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    // This could be derived from backend with additional rules like minimum uppercase, lowercase, special character requirements.
    // For now validating the minimum number of characters
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 8
    }

    func submitTapped(avatar: UIImage?, firstName: String?, email: String, password: String, website: String?) {
        // Not compressing the image here. The compression can be applied if there is a requirement
        // to only allow the image upload up to certain size limit
        let imageData = avatar?.jpegData(compressionQuality: 1.0) ?? nil
        profile = Profile(avatar: imageData,
                          firstName: firstName,
                          email: email,
                          password: password,
                          website: website)

        networkService.submitProfile(profile: profile) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.viewDelegate?.loginHandler(profile: profile)
            case .failure:
                // Out of scope: handle error
                break
            }
        }
    }
}
