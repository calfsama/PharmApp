//
//  SearchBarViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 10/03/23.
//

import UIKit

class SearchBarViewController: UIViewController {
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
    
    func configure() {
        view.addSubview(searchView)
        searchView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            searchView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            searchView.heightAnchor.constraint(equalToConstant: 40),
            
            searchBar.topAnchor.constraint(equalTo: searchView.topAnchor),
            searchBar.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            searchBar.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 10),
            searchBar.bottomAnchor.constraint(equalTo: searchView.bottomAnchor)
        ])
    }
}
