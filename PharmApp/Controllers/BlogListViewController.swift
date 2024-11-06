//
//  BlogListViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 19/09/22.
//

import UIKit

class BlogListViewController: UIViewController {
    var blogListCollectionView: BlogListCollectionView!
    var network = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBlogData()
        view.backgroundColor = .white
        navigationItem.title = "Блог"
        blogListCollectionView = BlogListCollectionView(nav: self.navigationController!)
        configureConstraints()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
    }
    
    func configureConstraints() {
        view.addSubview(blogListCollectionView)
        
        NSLayoutConstraint.activate([
            blogListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            blogListCollectionView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            blogListCollectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height)
        ])
    }
    
    func fetchBlogData(){
        let urlString = "/blogs/blog_popular?page=1"
        self.network.fetchBlogsData(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.blogListCollectionView.blogs = response
                self.blogListCollectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
