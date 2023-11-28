//
//  ProfileEditingVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/21.
//  Copyright © 2023 traveline. All rights reserved.
//

import PhotosUI
import UIKit

final class ProfileEditingVC: UIViewController {
    
    private enum Metric {
        static let topInset: CGFloat = 24
        static let margin: CGFloat = 16
        static let imageWidth: CGFloat = 120
        static let textFieldPaddingMargin: CGFloat = 12
        static let textFieldPaddingHeight: CGFloat = 40
        static let textFieldPaddingCornerRadius: CGFloat = 12
        static let textFieldPaddingBorderWidth: CGFloat = 1
        static let textFieldPaddingBottomInset: CGFloat = 8
        static let textFieldWidthOffset: CGFloat = textFieldPaddingMargin * 2
        static let buttonWidth: CGFloat = 36
        static let buttonImagePadding: CGFloat = 6
    }
    
    private enum Constants {
        static let title: String = "프로필 수정"
        static let complete: String = "완료"
        static let nickName: String = "닉네임"
        static let selectBaseImage: String = "기본 이미지"
        static let selectInAlbum: String = "앨범에서 선택"
        static let close: String = "닫기"
    }
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Metric.imageWidth / 2
        view.backgroundColor = TLColor.backgroundGray
        view.clipsToBounds = true
        return view
    }()
    
    private let imageEditButton: UIButton = {
        let button = UIButton()
        button.setImage(TLImage.Common.camera, for: .normal)
        button.tintColor = TLColor.black
        button.layer.cornerRadius = Metric.buttonWidth / 2
        button.backgroundColor = TLColor.white
        
        return button
    }()
    
    private let nickNameLabel: TLLabel = {
        let label = TLLabel(font: TLFont.subtitle1, color: TLColor.white)
        label.text = Constants.nickName
        
        return label
    }()
    
    private let textFieldPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = TLColor.backgroundGray
        view.layer.cornerRadius = Metric.textFieldPaddingCornerRadius
        view.layer.borderWidth = Metric.textFieldPaddingBorderWidth
        view.layer.borderColor = TLColor.lineGray.cgColor
        
        return view
    }()
    
    private let nickNameTextField: UITextField = {
        let field = UITextField()
        field.font = TLFont.subtitle2.font
        
        return field
    }()
    
    private let captionLabel: TLLabel = {
        let label = TLLabel(font: TLFont.caption, color: TLColor.main)
        
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
    }
    
    // MARK: - Functions
    
    @objc private func imageEditButtonTapped() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        [
            UIAlertAction(title: Constants.selectBaseImage, style: .default) { _ in
                self.imageView.image = nil
            },
            UIAlertAction(title: Constants.selectInAlbum, style: .default) { _ in
                var config = PHPickerConfiguration()
                config.filter = .images
                
                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
                
                self.present(picker, animated: true)
            },
            UIAlertAction(title: Constants.close, style: .cancel)
        ].forEach { alert.addAction($0) }
        
        present(alert, animated: true)
    }
    
    @objc private func completeButtonTapped() {
        // action
    }
    
}

// MARK: - Setup Functions

extension ProfileEditingVC {
    
    private func setupAttributes() {
        setupNavigationItem()
        view.backgroundColor = TLColor.black
        
        imageEditButton.addTarget(self, action: #selector(imageEditButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = Constants.title
        let completeButton = UIBarButtonItem(
            title: Constants.complete,
            style: .plain,
            target: self,
            action: #selector(completeButtonTapped)
        )
        completeButton.isEnabled = false
        completeButton.setTitleTextAttributes([.font: TLFont.body1.font], for: .normal)
        completeButton.setTitleTextAttributes([.foregroundColor: TLColor.gray], for: .disabled)
        completeButton.setTitleTextAttributes([.foregroundColor: TLColor.main], for: .normal)
        self.navigationItem.rightBarButtonItem = completeButton
    }
    
    private func setupLayout() {
        view.addSubviews(
            imageView,
            imageEditButton,
            nickNameLabel,
            textFieldPaddingView,
            nickNameTextField,
            captionLabel
        )
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.topInset),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Metric.imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: Metric.imageWidth),
            
            imageEditButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            imageEditButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageEditButton.widthAnchor.constraint(equalToConstant: Metric.buttonWidth),
            imageEditButton.heightAnchor.constraint(equalToConstant: Metric.buttonWidth),
            
            nickNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Metric.topInset),
            nickNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            
            textFieldPaddingView.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: Metric.textFieldPaddingMargin),
            textFieldPaddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            textFieldPaddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.margin),
            textFieldPaddingView.heightAnchor.constraint(equalToConstant: Metric.textFieldPaddingHeight),
            
            nickNameTextField.centerXAnchor.constraint(equalTo: textFieldPaddingView.centerXAnchor),
            nickNameTextField.centerYAnchor.constraint(equalTo: textFieldPaddingView.centerYAnchor),
            nickNameTextField.widthAnchor.constraint(equalTo: textFieldPaddingView.widthAnchor, constant: -Metric.textFieldWidthOffset),
            
            captionLabel.topAnchor.constraint(equalTo: textFieldPaddingView.bottomAnchor, constant: Metric.textFieldPaddingBottomInset),
            captionLabel.leadingAnchor.constraint(equalTo: textFieldPaddingView.leadingAnchor, constant: Metric.textFieldPaddingMargin),
            captionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.margin)
        ])
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ProfileEditingVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        guard let itemProvider = itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let selectedImage = image as? UIImage else { return }
                self.imageView.image = selectedImage
            }
        }
    }
    
}

/*
@available(iOS 17, *)
#Preview("ProfileEditingVC") {
    let profileEditingVC = ProfileEditingVC()
    let homeNV = UINavigationController(rootViewController: profileEditingVC)
    return homeNV
}

*/
