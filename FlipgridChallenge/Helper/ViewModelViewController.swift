//
//  ViewModelViewController.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/25/21.
//

import UIKit

// Protocol for a view controller that enforces a relationship to a ViewModel
public protocol ViewModelViewController: UIViewController {
    associatedtype ViewModel
    var viewModel: ViewModel! { get set }
    static var storyboardName: String { get }
    static var viewControllerIdentifier: String { get }
}

public extension ViewModelViewController where Self: UIViewController {
    static var viewControllerIdentifier: String {
        return String(describing: self)
    }

    static func viewController(viewModel: ViewModel) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: Self.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? Self else {
            fatalError("\(String(describing: self)) creation failed.")
        }
        viewController.viewModel = viewModel

        return viewController
    }
}
