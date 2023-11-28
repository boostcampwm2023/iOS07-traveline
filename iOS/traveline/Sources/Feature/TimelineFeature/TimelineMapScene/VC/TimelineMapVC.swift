//
//  TimelineMapVC.swift
//  traveline
//
//  Created by 김태현 on 11/23/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import MapKit
import UIKit

final class TimelineMapVC: UIViewController {
    
    private enum Metric {
        static let horizontalInset: CGFloat = 16.0
    }
    
    private enum Constants {
        static let annotatinonIdentifier: String = "marker"
    }
    
    // MARK: - UI Componenets
    
    private lazy var tlNavigationBar: TLNavigationBar = .init(vc: self)
    
    private let mapView = MKMapView()
    private let timelineCardView: TimelineCardView = .init()
    
    // MARK: - Properties
    
    private var selectedAnnotation: MKAnnotation?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
    }
    
    // MARK: - Functions
    
    func setMarker(by cardList: TimelineCardList, day: Int) {
        let markerAnnotations = cardList.map {
            TLMarkerAnnotation(
                cardInfo: $0,
                coordinate: .init(
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            )
        }
        
        mapView.showAnnotations(markerAnnotations, animated: true)
        mapView.addAnnotations(markerAnnotations)
        tlNavigationBar.setupTitle(to: "Day \(day)")
    }
    
    @objc private func showTimelineDetail() {
        if let selected = selectedAnnotation as? TLMarkerAnnotation {
            let info = selected.cardInfo
            let timelineDetailVC = TimelineDetailVC(
                info: .init(
                    id: "1",
                    day: "Day 1",
                    title: info.title,
                    date: "2023.11.23",
                    time: "오후 02:00",
                    location: info.subtitle,
                    content: info.content,
                    imageURL: ""
                )
            )
            
            navigationController?.pushViewController(timelineDetailVC, animated: true)
        }
        
    }
}

// MARK: - Setup Functions

private extension TimelineMapVC {
    func setupAttributes() {
        view.backgroundColor = TLColor.black
        
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.delegate = self
        
        timelineCardView.addShadow(
            xOffset: 0,
            yOffset: 2,
            blur: 12,
            color: .black,
            alpha: 0.25
        )
        timelineCardView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showTimelineDetail))
        timelineCardView.addGestureRecognizer(tapGesture)
    }
    
    func setupLayout() {
        view.addSubviews(
            tlNavigationBar,
            mapView,
            timelineCardView
        )
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            tlNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tlNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tlNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tlNavigationBar.heightAnchor.constraint(equalToConstant: BaseMetric.tlheight),
            
            mapView.topAnchor.constraint(equalTo: tlNavigationBar.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            timelineCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.horizontalInset),
            timelineCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.horizontalInset),
            timelineCardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - MKMapViewDelegate

extension TimelineMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotatinonIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotatinonIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = TLImage.Travel.marker
        
        if let imageHeight = annotationView?.bounds.height {
            annotationView?.centerOffset = .init(x: 0, y: -imageHeight / 2)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let markerAnnotation = view.annotation as? TLMarkerAnnotation else { return }
        
        if let selectedAnnotation {
            mapView.deselectAnnotation(selectedAnnotation, animated: true)
        }
        
        view.image = TLImage.Travel.markerSelected
        selectedAnnotation = view.annotation
        
        timelineCardView.setData(cardInfo: markerAnnotation.cardInfo)
        timelineCardView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = TLImage.Travel.marker
        timelineCardView.isHidden = true
    }
}

@available(iOS 17, *)
#Preview {
    let view = TimelineMapVC()
    view.setMarker(by: TimelineSample.makeCardList(), day: 1)
    return view
}
