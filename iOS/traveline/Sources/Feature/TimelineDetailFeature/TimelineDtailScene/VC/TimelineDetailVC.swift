//
//  TimelineDetailVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/21.
//  Copyright © 2023 traveline. All rights reserved.
//

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
    
    // MARK: - Initialize
    
    init(info: TimelineDetailInfo) {
        super.init(nibName: nil, bundle: nil)
        
        initInfo(from: info)
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initInfo(from info: TimelineDetailInfo) {
        self.navigationItem.title = info.day
        titleLabel.setText(to: info.title)
        dateLabel.setText(to: info.date)
        timeLabel.setText(to: info.time)
        locationLabel.setText(to: info.location)
        imageView.image = UIImage(systemName: "leaf")
        contentView.setText(to: info.content)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    private func aspectRatio(from image: UIImage) -> CGFloat {
        return image.size.width / image.size.height
    }
    
}

// MARK: - Setup Functions

private extension TimelineDetailVC {
    
    func setupAttributes() {
        view.backgroundColor = TLColor.black
    }
    
    func setupLayout() {
        view.addSubview(scrollView)
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.arrangedSubviews.forEach { 
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
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
}

@available(iOS 17, *)
#Preview("TimelineDetailVC") {
    let info = TimelineDetailInfo(
        id: "a1b2c3d4",
        day: "day02",
        title: "광안리 짱",
        date: "2023년 12월 15일",
        time: "오후 02:00",
        location: "부산 광안리 해수욕장",
        content: "광안리 짱짱맨",
        imageURL: "http://sigan.nermoo.bballa"
    )
    let timelineDetailVC = TimelineDetailVC(info: info)
    let homeNV = UINavigationController(rootViewController: timelineDetailVC)
    return homeNV
}
