//
//  ConfirmationViewModel.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/21/21.
//

import UIKit

class ConfirmationViewModel {
    private var profile: Profile! // Its expected to have the profile is initialized before

    init(profile: Profile) {
        self.profile = profile
    }

    var helloUserText: String {
        // Using a default text `User` when a user has not chosen first name during profile creation
        let userName = isFirstNameEmpty ? "User" : profile.firstName!
        let localizedString = String.localizedStringWithFormat("%@, %@!", "Hello", userName)
        return localizedString
    }

    var avatarImage: UIImage? {
        guard let imageData = profile.avatar, let image = UIImage(data: imageData) else {
            // Assumption: showing a default avatar when user has not chosen any avatar during profile creation
            return UIImage(systemName: "person.fill")
        }
        return image
    }

    var isWebsiteEmpty: Bool {
        return websiteText?.isEmpty ?? false
    }

    var websiteText: String? {
        return profile.website?.trimmingCharacters(in: .whitespaces)
    }

    var isFirstNameEmpty: Bool {
        return firstName?.isEmpty ?? false
    }

    var firstName: String? {
        return profile.firstName?.trimmingCharacters(in: .whitespaces)
    }

    var email: String? {
        return profile.email
    }
}
