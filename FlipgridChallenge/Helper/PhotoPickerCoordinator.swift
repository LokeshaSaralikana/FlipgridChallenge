//
//  PhotoPickerCoordinator.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/21/21.
//

import UIKit
import Photos

protocol PhotoPickerCoordinatorDelegate: AnyObject {
    func photoSelected(image: UIImage?)
}

class PhotoPickerCoordinator: NSObject {
    var baseViewController: UIViewController?
    weak var delegate: PhotoPickerCoordinatorDelegate?

    init(baseViewController: UIViewController?, delegate: PhotoPickerCoordinatorDelegate?) {
        self.baseViewController = baseViewController
        self.delegate = delegate
    }

    /// start() begins the photo picker process by presenting an action sheet with photo selection options
    /// Based on user selections the user will be taken to the corresponding view controller
    func start() {
        let takePhotoString = NSLocalizedString("Take Photo", comment: "Take Photo")
        let takePhotoAction = UIAlertAction(title: takePhotoString, style: .default) { [weak self] _ in
            self?.takePhotoSelected()
        }

        let chooseFromLibraryString = NSLocalizedString("Choose from Library", comment: "Choose from Library")
        let chooseFromLibraryAction = UIAlertAction(title: chooseFromLibraryString, style: .default) { [weak self] _ in
            self?.chooseFromLibrarySelected()
        }

        let actions = [takePhotoAction, chooseFromLibraryAction]

        baseViewController?.presentActionSheet(title: nil, message: nil, actions: actions)
    }

    private func takePhotoSelected() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            capturePhoto(from: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.capturePhoto(from: .camera)
                }
            }
        case .denied:
            // TODO: Show access denied alert with an option to change the selection in app Settings
            break
        default:
            break
        }
    }

    private func chooseFromLibrarySelected() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            capturePhoto(from: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {
                    self?.capturePhoto(from: .photoLibrary)
                }
            }
        case .denied:
            // TODO: Show access denied alert with an option to change the selection in app Settings
            break
        default:
            break
        }
    }

    private func capturePhoto(from sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            DispatchQueue.main.async {
                let imagePickerController = self.imagePickerController(with: sourceType)
                self.baseViewController?.present(imagePickerController, animated: true)
            }
        }
    }

    private func imagePickerController(with sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        if sourceType == .camera {
            imagePickerController.cameraDevice = .rear
        } else if sourceType == .photoLibrary, UIDevice.current.userInterfaceIdiom == .pad { // support for iPad
            imagePickerController.modalPresentationStyle = .popover
            let popOver = imagePickerController.popoverPresentationController
            if let baseViewController = baseViewController {
                popOver?.sourceView = baseViewController.view
                popOver?.sourceRect = CGRect(x: baseViewController.view.bounds.midX, y: baseViewController.view.bounds.midY, width: 0, height: 0)
            }
            popOver?.permittedArrowDirections = []
        }
        imagePickerController.allowsEditing = true
        return imagePickerController
    }
}

extension PhotoPickerCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let croppedImage = info[.editedImage] as? UIImage {
            delegate?.photoSelected(image: croppedImage)
            baseViewController?.dismiss(animated: true)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        baseViewController?.dismiss(animated: true)
    }
}
