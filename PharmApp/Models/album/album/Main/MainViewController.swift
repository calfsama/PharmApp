//
//  ViewController.swift
//  album
//
//  Created by Tomiris Negmatova on 01/11/22.
//

import UIKit

class MainViewController: UIViewController {
    var storyCollectionView = StoryCollectionView()
    var postCollecctionView = PostCollectionView()
    
    lazy var titleScreen: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.backgroundColor = .systemBackground
        view.backgroundColor =  UIColor(red: 0.93, green: 0.963, blue: 0.975, alpha: 1)
        
        navigationItem.title = "Coupling"
        configureConstraints()
    }
    
    func configureConstraints() {
        storyCollectionView.backgroundColor = UIColor(red: 0.93, green: 0.963, blue: 0.975, alpha: 1)
        postCollecctionView.backgroundColor = UIColor(red: 0.93, green: 0.963, blue: 0.975, alpha: 1)
        view.addSubview(storyCollectionView)
        view.addSubview(postCollecctionView)
        view.addSubview(titleScreen)
        
        NSLayoutConstraint.activate([
            
            storyCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            storyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storyCollectionView.heightAnchor.constraint(equalToConstant: 45),
            
            titleScreen.topAnchor.constraint(equalTo: storyCollectionView.bottomAnchor, constant: 15),
            titleScreen.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            postCollecctionView.topAnchor.constraint(equalTo: titleScreen.bottomAnchor, constant: 15),
            postCollecctionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postCollecctionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postCollecctionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

