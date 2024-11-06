//
//  TermsOfUseViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 08/12/22.
//

import UIKit

class TermsOfUseViewController: UIViewController {
    
    lazy var header: UILabel = {
        let label = UILabel()
        label.text = "1. Общие положения"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Условия пользования"
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close 1"), style: .plain, target: self, action: #selector(close))
        configureConstraints()
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureConstraints() {
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
