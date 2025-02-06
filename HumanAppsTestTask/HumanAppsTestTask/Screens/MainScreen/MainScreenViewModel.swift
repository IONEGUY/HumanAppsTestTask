//
//  MainScreenViewModel.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import UIKit
import Photos

extension MainScreenViewModel {
    struct Constants {
        static let savedTitle = "Saved"
        static let savedMessage = "Image has been saved to the gallery"
        static let errorTitle = "Error"
        static let accessNotGrantedError = "Photo didn't saved. Please grant access to the gallery!"
    }
}

final class MainScreenViewModel: BaseViewModel {
    private(set) var image = Observable<UIImage?>(nil)
    
    private var originalImage: UIImage?
    
    var isPhotoLibraryReadWriteAccessGranted: Bool {
        get async {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
            }
            
            return isAuthorized
        }
    }

    func updateImage(_ newImage: UIImage) {
        originalImage = newImage
        image.value = newImage
    }

    func applyFilter(isBlackAndWhite: Bool) {
        guard let originalImage = originalImage else { return }
        if isBlackAndWhite {
            image.value = applyBlackAndWhiteFilter(to: originalImage)
        } else {
            image.value = originalImage
        }
    }

    func savePhoto() {
        guard let photoData = image.value?.pngData() else { return }
        
        Task {
            if !(await isPhotoLibraryReadWriteAccessGranted) {
                alertMessage.value = (title: Constants.errorTitle, description: Constants.accessNotGrantedError)
                return
            }
            
            do {
                try await PHPhotoLibrary.shared().performChanges {
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: photoData, options: nil)
                }
            } catch let error {
                alertMessage.value = (title: Constants.errorTitle, description: error.localizedDescription)
                return
            }
            
            alertMessage.value = (title: Constants.savedTitle, description: Constants.savedMessage)
        }
    }
}

// MARK: - Private
private extension MainScreenViewModel {
    func applyBlackAndWhiteFilter(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filterNama = "CIPhotoEffectMono"
        let filter = CIFilter(name: filterNama)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = filter?.outputImage else { return nil }
        
        return UIImage(ciImage: outputImage)
    }
}
