//
//  TravelVC.swift
//  traveline
//
//  Created by 김태현 on 2023/11/16.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

final class TravelVC: UIViewController {
    
    private enum Metric {
        static let horizontalInset: CGFloat = 16.0
        static let spacing: CGFloat = 20.0
        static let width: CGFloat = BaseMetric.ScreenSize.width - 32.0
        static let borderWidth: CGFloat = 1.0
        static let bottomSheetHeight: CGFloat = BaseMetric.ScreenSize.height * 0.7
    }
    
    private enum Constants {
        static let titleLimit: Int = 14
        static let titleLimitToastMessage = "제목은 1 - 14자 이내만 가능합니다."
        static let title: String = "여행 생성"
        static let textFieldPlaceholder: String = "제목 *"
        static let done: String = "완료"
        static let bottomSheetTitle: String = "지역"
    }
    
    // MARK: - UI Components
    
    private lazy var tlNavigationBar: TLNavigationBar = .init(title: Constants.title, vc: self)
        .addCompleteButton()
    
    private let baseScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    private let titleTextField: TitleTextField = .init()
    private let selectRegionButton: SelectRegionButton = .init()
    private let selectPeriodView: SelectPeriodView = .init()
    
    private let tagBorderView: UIView = {
        let view = UIView()
        
        view.backgroundColor = TLColor.backgroundGray
        
        return view
    }()
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = Metric.spacing
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let peopleTagView: SelectTagView = .init(tagType: .people, width: Metric.width)
    private let transportationTagView: SelectTagView = .init(tagType: .transportation, width: Metric.width)
    private let themeTagView: SelectTagView = .init(tagType: .theme, width: Metric.width)
    private let withTagView: SelectTagView = .init(tagType: .with, width: Metric.width)
    private let costTagView: SelectTagView = .init(tagType: .cost, width: Metric.width)
    
    private lazy var tagViews: [SelectTagView] = [
        peopleTagView,
        transportationTagView,
        themeTagView,
        withTagView,
        costTagView
    ]
    
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: TravelViewModel
    private let regionBottomSheetVC = RegionBottomSheetVC(
        title: Constants.bottomSheetTitle,
        hasCompleteButton: false,
        detentHeight: Metric.bottomSheetHeight
    )
    
    // MARK: - Initializer
    
    init(viewModel: TravelViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
        setupKeyboard()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Functions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func selectRegion() {
        regionBottomSheetVC.delegate = self
        present(regionBottomSheetVC, animated: true)
    }
    
    @objc private func selectStartDate(_ sender: UIDatePicker) {
        let startDate = sender.date
        viewModel.sendAction(.startDateSelected(startDate))
        
        dismiss(animated: false)
    }
    
    @objc private func selectEndDate(_ sender: UIDatePicker) {
        let endDate = sender.date
        viewModel.sendAction(.endDateSelected(endDate))
        
        dismiss(animated: false)
    }
    
}

// MARK: - Setup Functions

private extension TravelVC {
    func setupAttributes() {
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        view.backgroundColor = TLColor.black
        titleTextField.placeholder = Constants.textFieldPlaceholder
        baseScrollView.delegate = self
        titleTextField.delegate = self
        selectRegionButton.addTarget(self, action: #selector(selectRegion), for: .touchUpInside)
        selectPeriodView.startDatePicker.addTarget(self, action: #selector(selectStartDate(_:)), for: .primaryActionTriggered)
        selectPeriodView.endDatePicker.addTarget(self, action: #selector(selectEndDate(_:)), for: .valueChanged)
        
        tlNavigationBar.delegate = self
    }
    
    func setupLayout() {
        view.addSubviews(
            tlNavigationBar,
            baseScrollView
        )
        baseScrollView.addSubviews(
            titleTextField,
            selectRegionButton,
            selectPeriodView,
            tagBorderView,
            tagStackView
        )
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        baseScrollView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        tagStackView.addArrangedSubviews(
            peopleTagView,
            transportationTagView,
            themeTagView,
            withTagView,
            costTagView
        )
        
        NSLayoutConstraint.activate([
            tlNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tlNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tlNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tlNavigationBar.heightAnchor.constraint(equalToConstant: BaseMetric.tlheight),
            
            baseScrollView.topAnchor.constraint(equalTo: tlNavigationBar.bottomAnchor),
            baseScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            baseScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: baseScrollView.topAnchor, constant: 24.0),
            titleTextField.leadingAnchor.constraint(equalTo: baseScrollView.frameLayoutGuide.leadingAnchor, constant: Metric.horizontalInset),
            titleTextField.trailingAnchor.constraint(equalTo: baseScrollView.frameLayoutGuide.trailingAnchor, constant: -Metric.horizontalInset),
            
            selectRegionButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Metric.spacing),
            selectRegionButton.leadingAnchor.constraint(equalTo: baseScrollView.frameLayoutGuide.leadingAnchor, constant: Metric.horizontalInset),
            selectRegionButton.heightAnchor.constraint(equalToConstant: 24.0),
            
            selectPeriodView.topAnchor.constraint(equalTo: selectRegionButton.bottomAnchor, constant: 16.0),
            selectPeriodView.leadingAnchor.constraint(equalTo: baseScrollView.frameLayoutGuide.leadingAnchor, constant: Metric.horizontalInset),
            selectPeriodView.trailingAnchor.constraint(equalTo: baseScrollView.frameLayoutGuide.trailingAnchor, constant: -Metric.horizontalInset),
            selectPeriodView.heightAnchor.constraint(equalToConstant: 34.0),
            
            tagBorderView.topAnchor.constraint(equalTo: selectPeriodView.bottomAnchor, constant: Metric.spacing),
            tagBorderView.leadingAnchor.constraint(equalTo: baseScrollView.frameLayoutGuide.leadingAnchor, constant: Metric.horizontalInset),
            tagBorderView.trailingAnchor.constraint(equalTo: baseScrollView.frameLayoutGuide.trailingAnchor, constant: -Metric.horizontalInset),
            tagBorderView.heightAnchor.constraint(equalToConstant: Metric.borderWidth),
            
            tagStackView.topAnchor.constraint(equalTo: tagBorderView.bottomAnchor, constant: Metric.spacing),
            tagStackView.leadingAnchor.constraint(equalTo: baseScrollView.frameLayoutGuide.leadingAnchor, constant: Metric.horizontalInset),
            tagStackView.trailingAnchor.constraint(equalTo: baseScrollView.frameLayoutGuide.trailingAnchor, constant: -Metric.horizontalInset),
            tagStackView.bottomAnchor.constraint(equalTo: baseScrollView.bottomAnchor)
        ])
    }
    
    func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        baseScrollView.addGestureRecognizer(tapGesture)
    }
    
    func setupEditableView(info: TravelEditableInfo) {
        titleTextField.text = info.travelTitle
        
        info.tags.forEach { tag in
            tagViews.forEach { view in
                if view.tagType == tag.type {
                    view.setSelectedTag(tag: tag)
                }
            }
        }
        
        guard let region = info.region,
              let startDate = info.startDate,
              let endDate = info.endDate else { return }
        
        selectRegionButton.setSelectedTitle(region.title)
        selectPeriodView.startDatePicker.date = startDate
        selectPeriodView.endDatePicker.date = endDate
    }
    
    func bind() {
        titleTextField
            .textPublisher
            .withUnretained(self)
            .sink { owner, text in
                owner.viewModel.sendAction(.titleEdited(text))
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.canPost)
            .removeDuplicates()
            .withUnretained(self)
            .filter { owner, _ in
                !owner.viewModel.currentState.isEdit
            }
            .sink { owner, canPost in
                owner.tlNavigationBar.isRightButtonEnabled(canPost)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.canPost)
            .withUnretained(self)
            .filter { owner, _ in
                owner.viewModel.currentState.isEdit
            }
            .dropFirst()
            .sink { owner, canPost in
                owner.tlNavigationBar.isRightButtonEnabled(canPost)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.startDate)
            .withUnretained(self)
            .sink { owner, startDate in
                owner.selectPeriodView.endDatePicker.minimumDate = startDate
                owner.selectPeriodView.endDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.endDate)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, endDate in
                owner.selectPeriodView.endDatePicker.date = endDate
            }
            .store(in: &cancellables)
        
        viewModel.state
            .compactMap(\.travelID)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, id in
                if owner.viewModel.currentState.isEdit {
                    owner.navigationController?.popViewController(animated: true)
                    return
                }
                
                let timelineVC = VCFactory.makeTimelineVC(id: id)
                guard var vcs = owner.navigationController?.viewControllers else { return }
                vcs.removeLast()
                vcs.append(timelineVC)
                owner.navigationController?.setViewControllers(vcs, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .compactMap(\.titleValidation)
            .filter { $0 == .invalidate }
            .removeDuplicates()
            .withUnretained(self)
            .sink { _, _ in
                // TODO: - 토스트로 띄우기
                print("제목은 1 - 14자 이내만 가능합니다.")
            }
            .store(in: &cancellables)
        
        viewModel.state
            .compactMap(\.travelInfo)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, travelInfo in
                owner.setupEditableView(info: travelInfo)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UIScrollView Delegate

extension TravelVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}

// MARK: - UITextField Delegate

extension TravelVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        if text.count + string.count > Constants.titleLimit {
            let textLimitToast = TLToastView(type: .failure, message: Constants.titleLimitToastMessage, followsUndockedKeyboard: true)
            textLimitToast.show(in: self.view)
            return false
        }
        return true
    }
}

// MARK: - TLBottomSheetDelegate

extension TravelVC: TLBottomSheetDelegate {
    func bottomSheetDidDisappear(data: Any) {
        guard let region = data as? RegionFilter else { return }
        selectRegionButton.setSelectedTitle(region.title)
        viewModel.sendAction(.regionSelected(region.query))
    }
}

// MARK: - TLNavigationBarDelegate

extension TravelVC: TLNavigationBarDelegate {
    func rightButtonDidTapped() {
        let selectedTags = [
            peopleTagView.selectedTags.map { Tag(title: $0, type: .people) },
            transportationTagView.selectedTags.map { Tag(title: $0, type: .transportation) },
            themeTagView.selectedTags.map { Tag(title: $0, type: .theme) },
            withTagView.selectedTags.map { Tag(title: $0, type: .with) },
            costTagView.selectedTags.map { Tag(title: $0, type: .cost) }
        ].flatMap({ $0 })
        
        viewModel.sendAction(.donePressed(selectedTags))
    }
}

@available(iOS 17, *)
#Preview {
    return UINavigationController(rootViewController: VCFactory.makeTravelVC())
}
