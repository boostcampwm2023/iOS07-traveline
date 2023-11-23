//
//  TimelineWritingVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/22.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit
import PhotosUI

final class TimelineWritingVC: UIViewController {
    
    private enum Metric {
        static let topInset: CGFloat = 24
        static let margin: CGFloat = 16
        static let spacing: CGFloat = 20
        static let belowLine: CGFloat = 4
    }
    
    private enum Constants {
        static let titlePlaceholder: String = "제목 *"
        static let contentPlaceholder: String = "내용을 입력해주세요. *"
        static let complete: String = "완료"
        static let alertContentVCKey = "contentViewController"
    }
    
    // MARK: - UI Components
    
    private let timePickerVC = TimePickerVC()
    private let titleTextField: TitleTextField = .init()
    private let dateLabel: TLLabel = .init(font: TLFont.body2, color: TLColor.gray)
    private let selectTime: TLImageLabel = .init(image: TLImage.Travel.time, text: "현재시각")
  //  private let selectLocation: TLImageLabel = .init(image: TLImage.Travel.location, text: "선택한 장소")
    private let selectLocation: SelectLocationButton = .init()
    private let selectImageButton: SelectImageButton = .init()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.text = Constants.contentPlaceholder
        view.textColor = TLColor.disabledGray
        view.font = TLFont.body1.font
        view.backgroundColor = TLColor.black
        
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
        dateLabel.setText(to: "2023년 11월 9일")
    }
    
    // MARK: - Functions
    
    @objc private func selectImageButtonTapped() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    @objc private func completeButtonTapped() {
        // action
    }
    
    @objc private func selectLocationButtonTapped() {
        // action
        let locationSearchVC = LocationSearchVC()
        locationSearchVC.delegate = self
        
        present(locationSearchVC, animated: true)
    }
    
    @objc private func selectTimeButtonTapped() {
        let alert = TLAlertController(title: "시간선택", message: nil, preferredStyle: .alert)
        let complete = UIAlertAction(title: Constants.complete, style: .default) { [weak self] _ in
            guard let self else { return }
            self.updateTime()
        }
        
        alert.addAction(complete)
        alert.setValue(timePickerVC, forKey: Constants.alertContentVCKey)
        
        present(alert, animated: true)
    }
    
    private func updateTime() {
        selectTime.setText(to: timePickerVC.time)
    }
}

// MARK: - Setup Functions

private extension TimelineWritingVC {
    
    func setupAttributes() {
        view.backgroundColor = TLColor.black
        titleTextField.placeholder = Constants.titlePlaceholder
        textView.delegate = self
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageButtonTapped))
        let timeTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectTimeButtonTapped))
        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectLocationButtonTapped))
        selectImageButton.addGestureRecognizer(imageTapGesture)
        selectTime.addGestureRecognizer(timeTapGesture)
        selectLocation.addGestureRecognizer(locationTapGesture)
        selectImageButton.isUserInteractionEnabled = true
        selectTime.isUserInteractionEnabled = true
        selectLocation.isUserInteractionEnabled = true
        updateTime()
    }
    
    func setupNavigationItem() {
        self.navigationItem.title = "Day01"
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
    
    func setupLayout() {
        view.addSubviews(
            titleTextField,
            dateLabel,
            selectTime,
            selectLocation,
            selectImageButton,
            textView
        )
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.topInset),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.margin),
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Metric.belowLine),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.margin),
            selectTime.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Metric.spacing),
            selectTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            selectTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.margin),
            selectLocation.topAnchor.constraint(equalTo: selectTime.bottomAnchor, constant: Metric.spacing),
            selectLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            selectLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.margin),
            selectImageButton.topAnchor.constraint(equalTo: selectLocation.bottomAnchor, constant: Metric.spacing),
            selectImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            selectImageButton.widthAnchor.constraint(equalToConstant: selectImageButton.width),
            textView.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: Metric.spacing),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.margin),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITextViewDelegate

extension TimelineWritingVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == TLColor.disabledGray {
            textView.text = nil
            textView.textColor = TLColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.contentPlaceholder
            textView.textColor = TLColor.disabledGray
        }
    }
}

// MARK: - PHPPickerViewControllerDelegate 

extension TimelineWritingVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        guard let itemProvider = itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let selectedImage = image as? UIImage else { return }
                self.selectImageButton.setImage(selectedImage)
            }
        }
    }
    
}

extension TimelineWritingVC: LocationSearchDelegate {
    func selectedLocation(result: String) {
        selectLocation.setText(to: result)
    }
    
}

@available(iOS 17, *)
#Preview("TimelineWritingVC") {
    let timelineWritingVC = TimelineWritingVC()
    let homeNV = UINavigationController(rootViewController: timelineWritingVC)
    return homeNV
}

