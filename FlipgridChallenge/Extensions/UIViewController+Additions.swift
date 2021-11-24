//
//  UIViewController+Additions.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/20/21.
//

import UIKit

extension UIViewController {

    /// Transition a new child UIViewController to this UIViewController's child's
    /// array, and add the child's view as a subview to this UIViewController's view.
    /// The new child's view will fill this UIViewController's view, essentially
    /// becoming the visible content of this UIViewController.
    /// If this UIViewController has an existing child UIViewController, that existing
    /// child and it's view will be replaced with the new child and child's view.
    func transition(to newChild: UIViewController, duration: TimeInterval = 0.3) {
        let existingChild = children.last
        addChild(newChild)

        guard let newChildView = newChild.view else {
            return
        }

        // ensure newChildView fills this UIViewController's view bounds
        newChildView.translatesAutoresizingMaskIntoConstraints = true
        newChildView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newChildView.frame = view.bounds

        if let existingChild = existingChild { // replace an existing child UIViewController
            existingChild.willMove(toParent: nil)

            transition(from: existingChild, to: newChild, duration: duration, options: [.transitionCrossDissolve]) {

            } completion: { done in
                existingChild.removeFromParent()
                newChild.didMove(toParent: self)
            }
        } else { // no existing child, add as a subview to this UIViewController's view
            view.addSubview(newChildView)
            UIView.animate(withDuration: duration, delay: 0, options: [.transitionCrossDissolve]) {

            } completion: { done in
                newChild.didMove(toParent: self)
            }
        }
    }

    /// Present action sheet for ipad and iphone based on parameters
    /// - Parameter title: Title for actionsheet
    /// - Parameter message: Message for actionsheet
    /// - Parameter actions: Actions for actionsheet
    /// - Parameter showCancel: Bool to add a cancel action item
    func presentActionSheet(title: String?, message: String?, actions: [UIAlertAction], showCancel: Bool = true) {
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        for action in actions {
            actionSheetController.addAction(action)
        }

        if showCancel {
            let cancelString = NSLocalizedString("Cancel", comment: "Cancel")
            let cancelAction = UIAlertAction(title: cancelString, style: .cancel)
            actionSheetController.addAction(cancelAction)
        }

        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(actionSheetController, animated: true)
    }
}
