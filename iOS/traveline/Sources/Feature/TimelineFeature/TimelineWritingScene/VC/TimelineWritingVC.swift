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
    
    private enum KeyboardState {
        static let willShow = "UIKeyboardWillShowNotification"
        static let willHide = "UIKeyboardWillHideNotification"
    }
    
    private enum Constants {
        static let titlePlaceholder: String = "제목 *"
        static let contentPlaceholder: String = "내용을 입력해주세요. *"
        static let complete: String = "완료"
        static let selectTime: String = "시간선택"
        static let alertContentVCKey = "contentViewController"
    }
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = .init()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Metric.spacing
        
        return view
    }()
    
    private lazy var tlNavigationBar: TLNavigationBar = .init(vc: self)
        .addCompleteButton()
    
    private let timePickerVC = TimePickerVC()
    private let titleTextField: TitleTextField = .init()
    private let dateLabel: TLLabel = .init(font: TLFont.body2, color: TLColor.gray)
    private let selectTime: TLImageLabel = .init(image: TLImage.Travel.time, text: "현재시각")
    private let selectLocation: SelectLocationButton = .init()
    private let selectImageButton: SelectImageButton = .init()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.text = Constants.contentPlaceholder
        view.textColor = TLColor.disabledGray
        view.font = TLFont.body1.font
        view.isScrollEnabled = false
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
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    @objc private func completeButtonTapped() {
        // action
    }
    
    @objc private func selectLocationButtonTapped() {
        let locationSearchVC = LocationSearchVC()
        locationSearchVC.delegate = self
        
        present(locationSearchVC, animated: true)
    }
    
    @objc private func selectTimeButtonTapped() {
        let alert = TLAlertController(
            title: Constants.selectTime,
            message: nil,
            preferredStyle: .alert
        )
        
        let complete = UIAlertAction(
            title: Constants.complete,
            style: .default
        ) { [weak self] _ in
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
    
    @objc private func scrollViewTouched() {
        textView.becomeFirstResponder()
    }
    
    @objc private func keyboardNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        switch notification.name.rawValue {
        case KeyboardState.willShow:
            actionKeyboardWillShow(keyboardFrame)
        case KeyboardState.willHide:
            actionKeyboardWillHide()
        default: break
        }
    }
    
    private func actionKeyboardWillShow(_ keyboardFrame: CGRect) {
        self.scrollView.contentInset.bottom = keyboardFrame.size.height
        scrollView.scrollRectToVisible(textView.frame, animated: true)
    }
    
    private func actionKeyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}

// MARK: - Setup Functions

private extension TimelineWritingVC {
    
    func setupAttributes() {
        view.backgroundColor = TLColor.black
        
        titleTextField.placeholder = Constants.titlePlaceholder
        textView.delegate = self
        
        tlNavigationBar.delegate = self
        tlNavigationBar.setupTitle(to: "Day01") // TODO: - 추후 서버통신 후 수정
        
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTouched))
        tapGesture.delegate = self
        scrollView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupLayout() {
        
        view.addSubviews(tlNavigationBar, scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews(
            titleTextField,
            dateLabel,
            selectTime,
            selectLocation,
            selectImageButton,
            textView
        )
        
        tlNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: Metric.margin).isActive = true
            $0.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -Metric.margin).isActive = true
        }
        
        NSLayoutConstraint.activate([
            tlNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tlNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tlNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tlNavigationBar.heightAnchor.constraint(equalToConstant: BaseMetric.tlheight),

            scrollView.topAnchor.constraint(equalTo: tlNavigationBar.bottomAnchor, constant: Metric.topInset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textView.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: Metric.spacing),
            textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
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

// MARK: - extension LocationSearchDelegate

extension TimelineWritingVC: LocationSearchDelegate {
    func selectedLocation(result: String) {
        selectLocation.setText(to: result)
    }
}

// MARK: - TLNavigationBarDelegate

extension TimelineWritingVC: TLNavigationBarDelegate {
    func rightButtonDidTapped() {
        // TODO: 네비게이션 바 완료 버튼 선택
    }
}

extension TimelineWritingVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
        if view == scrollView {
            return true
        }
        return false
    }
}

@available(iOS 17, *)
#Preview("TimelineWritingVC") {
    let timelineWritingVC = TimelineWritingVC()
    let homeNV = UINavigationController(rootViewController: timelineWritingVC)
    return homeNV
}
