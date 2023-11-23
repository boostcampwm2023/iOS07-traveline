//
//  LocationSearchVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

protocol LocationSearchDelegate: AnyObject {
    func selectedLocation(result: String)
}

final class LocationSearchVC: UIViewController {
    
    // MARK: - UI Components
    
    private let header: UIView = .init()
    private let headerTitle: TLLabel = .init(
        font: TLFont.subtitle1,
        text: "장소 선택",
        color: TLColor.white
    )
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(TLImage.Tag.close, for: .normal)
        
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "여행 검색"
        searchBar.searchTextField.textColor = TLColor.white
        searchBar.barTintColor = TLColor.black
        searchBar.searchTextField.backgroundColor = TLColor.backgroundGray
        searchBar.backgroundColor = TLColor.black
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = TLColor.black
        
        return tableView
    }()
    
    // MARK: - Properties
    
    // TODO: - 임시 결과값으로 추후에는 빈 배열
    private var results: [String] = ["제주도 제주시", "제주도 서귀포시", "제주도 뭐뭐시"]
    weak var delegate: LocationSearchDelegate?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
    }
    
    // MARK: - Functions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    private func attributeString(from text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let length = text.count
        let range = (text as NSString).range(of: text)
        let colorRange = (text as NSString).range(of: String(text.dropLast(length - 1)))
        
        attributedString.addAttribute(
            .font,
            value: TLFont.body1.font,
            range: range
        )
        
        attributedString.addAttribute(
            .foregroundColor,
            value: TLColor.main,
            range: colorRange
        )
        return attributedString
    }
    
}

// MARK: - Setup Functions

extension LocationSearchVC {
    
    func setupAttributes() {
        view.backgroundColor = TLColor.black
        header.backgroundColor = TLColor.black
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        closeButton.addTarget(
            self,
            action: #selector(closeButtonTapped),
            for: .touchUpInside
        )
    }
    
    func setupLayout() {
        view.addSubviews(
            header,
            searchBar,
            tableView
        )
        header.addSubviews(
            closeButton,
            headerTitle
        )
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        header.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 52),
            
            closeButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            headerTitle.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            headerTitle.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            searchBar.topAnchor.constraint(equalTo: header.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 52),
           
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 27),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}

// MARK: - UISearchBarDelegate extension

extension LocationSearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
              !text.replacingOccurrences(of: " ", with: "").isEmpty else { return
        }
        // search result logic
    }
}

// MARK: - UITableViewDelegate extension

extension LocationSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let text = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
        delegate?.selectedLocation(result: text)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource extension
                            
extension LocationSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        let text = results[indexPath.row]
        cell.backgroundColor = TLColor.black
        cell.textLabel?.text = text
        cell.textLabel?.attributedText = attributeString(from: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}

@available(iOS 17, *)
#Preview("LocationSearchVC") {
    let vc = LocationSearchVC()
    let homeNV = UINavigationController(rootViewController: vc)
    return homeNV
}

