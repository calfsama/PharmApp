//
//  BlogCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 16/09/22.
//

import UIKit

class BlogCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var navigationController: UINavigationController
    var blogs: Blog?

    init(nav: UIViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.navigationController = nav as! UINavigationController
        super.init(frame: .zero, collectionViewLayout: layout)
        register(BlogCollectionViewCell.self, forCellWithReuseIdentifier: BlogCollectionViewCell.identifier)
        delegate = self
        dataSource = self
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss"

        if let date = inputFormatter.date(from: dateString) {

            let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format

            return outputFormatter.string(from: date)
        }

        return nil
    }
}
extension BlogCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: BlogCollectionViewCell.identifier, for: indexPath) as! BlogCollectionViewCell
        let data = blogs?.content?.blogs?[indexPath.row]
        cell.title.text = data?.blog_title ?? ""
        cell.descriptions.text = data?.blog_about ?? ""
        let date = formattedDateFromString(dateString: data?.blog_created_at ?? "", withFormat: "dd.mm.yyyy")
        cell.date.text = date
//        cell.date.text = data?.blog_created_at ?? ""
        cell.descriptions.attributedText = getAttributedDescriptionText(for: data?.blog_about ?? "", fontDescription: "NotoSansOriya", fontSize: 12)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.size.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let v = BlogShowViewController()
        v.title = "Блог"
        v.id = blogs?.content?.blogs?[indexPath.row].id ?? ""
        self.navigationController.pushViewController(v, animated: true)
    }
    
    func getAttributedDescriptionText(for descriptionString: String, fontDescription: String, fontSize: Int) -> NSAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
//        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = 18.0

        let attributedString = NSMutableAttributedString()
        let splits = descriptionString.components(separatedBy: "\n")
        _ = splits.map { string in
            let modifiedFont = String(format:"<span style=\"font-family: '\(fontDescription)'; font-size: \(fontSize)\">%@</span>", string)
            let data = modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)
            let attr = try? NSMutableAttributedString(
                data: data ?? Data(),
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            attributedString.append(attr ?? NSMutableAttributedString())
            if string != splits.last {
                attributedString.append(NSAttributedString(string: "\n"))
            }
        }
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}
