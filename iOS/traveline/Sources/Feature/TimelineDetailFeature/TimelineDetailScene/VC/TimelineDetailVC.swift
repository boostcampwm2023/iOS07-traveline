//
//  TimelineDetailVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/21.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

final class TimelineDetailVC: UIViewController {
    
    private enum Metric {
        static let topInset: CGFloat = 24
        static let margin: CGFloat = 16
        static let spacing: CGFloat = 20
        static let aboveLine: CGFloat = 12
        static let belowLine: CGFloat = 4
    }
    
    // MARK: - UI Components
    
    private lazy var tlNavigationBar: TLNavigationBar = .init(vc: self)
    
    private let scrollView: UIScrollView = .init()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Metric.spacing
        
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = TLColor.lineGray
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    private let contentView: TLLabel = {
        let view = TLLabel(font: TLFont.body1, color: TLColor.white)
        view.numberOfLines = 0
        
        return view
    }()
    
    private let titleLabel: TLLabel = .init(font: TLFont.heading1, color: TLColor.white)
    private let dateLabel: TLLabel = .init(font: TLFont.body2, color: TLColor.gray)
    private let timeLabel: TLImageLabel = .init(image: TLImage.Travel.time)
    private let locationLabel: TLImageLabel = .init(image: TLImage.Travel.location)
    
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: TimelineDetailViewModel
    
    // MARK: - Initialize
    
    init(viewModel: TimelineDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupAttributes()
        setupLayout()
        bind()
        viewModel.sendAction(.viewDidLoad)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func aspectRatio(from image: UIImage) -> CGFloat {
        return image.size.width / image.size.height
    }
    
    private func updateUI(with info: TimelineDetailInfo) {
        tlNavigationBar.setupTitle(to: "Day \(info.day)")
        titleLabel.setText(to: info.title)
        dateLabel.setText(to: info.date)
        timeLabel.setText(to: info.time)
        locationLabel.setText(to: info.location)
        contentView.setText(to: info.description)
        guard let url = info.imageURL else {
            imageView.isHidden = true
            return
        }
        imageView.isHidden = false
        imageView.setImage(from: url)
    }
    
}

// MARK: - Setup Functions

private extension TimelineDetailVC {
    
    func setupAttributes() {
        view.backgroundColor = TLColor.black
    }
    
    func setupLayout() {
        view.addSubviews(tlNavigationBar, scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews(
            titleLabel,
            line,
            dateLabel,
            timeLabel,
            locationLabel,
            imageView,
            contentView
        )
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.arrangedSubviews.forEach { 
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tlNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tlNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tlNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tlNavigationBar.heightAnchor.constraint(equalToConstant: BaseMetric.tlheight),
            
            scrollView.topAnchor.constraint(equalTo: tlNavigationBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: Metric.topInset),
            line.heightAnchor.constraint(equalToConstant: 1),
            imageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor,
                multiplier: 1.0 / aspectRatio(from: imageView.image ?? UIImage())
            )
        ])
        
        stackView.arrangedSubviews.forEach {
            guard $0 != imageView else { return }
            $0.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: Metric.margin).isActive = true
            $0.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -Metric.margin).isActive = true
        }
        
        stackView.setCustomSpacing(Metric.aboveLine, after: titleLabel)
        stackView.setCustomSpacing(Metric.belowLine, after: line)
        
    }
    
    private func bind() {
        
        viewModel.state
            .map(\.timelineDetailInfo)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, info in
                owner.updateUI(with: info)
            }
            .store(in: &cancellables)
    }
}
