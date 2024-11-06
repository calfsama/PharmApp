//
//  NotificationCollectionViewCell.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 22/11/22.
//

import UIKit

class NotificationCollectionViewCell: UICollectionViewCell {
    static let identifier = "NotificationCollectionViewCell"
    
    lazy var uiscrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = contentView.bounds
        scrollView.contentSize = CGSize(width: contentView.frame.size.width, height: 2350)
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        title.numberOfLines = 0
        title.text = "Добро пожаловать на Salomat.tj"
        title.alpha = 0.9
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        subtitle.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        subtitle.numberOfLines = 0
        subtitle.text = "Мы это молодая перспективная аптека, работающая на стыке сферы информационных технологий и фармацевтики. Наша интернет-аптека это большой выбор медикаментов (более 5000 видов), товаров для здоровья и красоты; это онлайн - сервис по предоставлению интересующей информации о препаратах; это возможность найти, сравнить цены и конечно же выгодно приобрести нужные вам лекарства не выходя из дома или офиса!"
        subtitle.lineBreakMode = .byWordWrapping
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        return subtitle
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if image != nil{
            // The imageView is not nil, set its constraints here
             // Make sure autoresizing masks are off
            configureConstraints()
            // Example constraints: set width and height to 100
            
            
        }
        else {
            configure()
        }
        
    }
        
    func configure() {
       // contentView.addSubview(uiscrollView)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        image.removeFromSuperview()
        
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            subtitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitle.bottomAnchor.constraint(equalTo: uiscrollView.bottomAnchor, constant: -10)
        
        ])
    }

    
    func configureConstraints() {
        //contentView.addSubview(uiscrollView)
        image.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        
    
        
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            image.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - 32),
//            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 250),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            title.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - 32),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            subtitle.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - 32),
//            subtitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            subtitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
