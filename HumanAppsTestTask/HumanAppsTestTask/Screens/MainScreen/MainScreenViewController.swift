//
//  MainScreenViewController.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import UIKit
import SnapKit

extension MainScreenViewController {
    struct Constants {
        static let switchTitle = "Original/BW"
        static let ok = "OK"
        static let saveButtonTitle = "Save"
        static let addButtonTitle = "Add"
        static let frameBorderWidth: CGFloat = 2.0
        static let frameBorderColor: UIColor = .yellow
        static let defaultPhotoViewSize: CGSize = CGSize(width: 200, height: 200)
    }
}

final class MainScreenViewController: BaseViewController<MainScreenViewModel> {
    override var navBarTitle: String { GlobalConstants.mainScreenTitle }
    
    private lazy var photoContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = Constants.frameBorderWidth
        view.layer.borderColor = Constants.frameBorderColor.cgColor
        view.isHidden = true
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var switchTitle: UILabel = {
        let view = UILabel()
        view.text = Constants.switchTitle
        view.textColor = .label
        view.font = .systemFont(ofSize: 16)
        return view
    }()

    private lazy var filterSwitch: UISwitch = {
        let filterSwitch = UISwitch()
        filterSwitch.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        return filterSwitch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupGestureRecognizers()
        setupNavigationBar()
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        viewModel.image.bind { [weak self] image in
            guard let self, let image else { return }
            
            photoImageView.image = image
            photoContainer.isHidden = false
            
            let aspectRatio = image.size.height / image.size.width
            let defaultHorizontalPaddingMultiplier: CGFloat = 0.6
            let photoImageViewWidth = min(image.size.width, view.bounds.width * defaultHorizontalPaddingMultiplier)
            let photoImageViewHeight = photoImageViewWidth * aspectRatio
            let photoImageViewSize: CGSize = .init(width: photoImageViewWidth, height: photoImageViewHeight)
            
            photoContainer.snp.updateConstraints { make in
                make.size.equalTo(photoImageViewSize)
            }
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: Constants.saveButtonTitle, style: .plain, target: self, action: #selector(savePhotoTapped)),
            UIBarButtonItem(title: Constants.addButtonTitle, style: .plain, target: self, action: #selector(addPhotoTapped))
        ]
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MainScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.updateImage(selectedImage)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension MainScreenViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { true }
}

// MARK: - Private
private extension MainScreenViewController {
    func setupLayout() {
        view.addSubview(filterSwitch)
        view.addSubview(switchTitle)
        view.addSubview(photoContainer)
        photoContainer.addSubview(photoImageView)

        photoContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.defaultPhotoViewSize)
        }

        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        filterSwitch.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        switchTitle.snp.makeConstraints { make in
            make.centerY.equalTo(filterSwitch)
            make.trailing.equalTo(filterSwitch.snp.leading).offset(-10)
        }
    }
    
    func setupGestureRecognizers() {
        [UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))),
         UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:))),
         UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
        ].forEach {
            $0.delegate = self
            photoContainer.addGestureRecognizer($0)
        }
    }

    @objc func addPhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    @objc func filterChanged(_ sender: UISwitch) {
        viewModel.applyFilter(isBlackAndWhite: sender.isOn)
    }

    @objc func savePhotoTapped() {
        viewModel.savePhoto()
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if let gestureView = gesture.view {
            gestureView.center = CGPoint(
                x: gestureView.center.x + translation.x,
                y: gestureView.center.y + translation.y
            )
            gesture.setTranslation(.zero, in: view)
        }
    }

    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
    }

    @objc func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
}
