//
//  NewsViewController.swift
//  SwiftNewsKit-Design1
//
//  Created by Austin Potts on 11/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import ReadabilityKit

class NewsViewController: UIViewController {
    
    // MARK: - Data
    
    let data = [
        CustomData(title: "Forbes", image: #imageLiteral(resourceName: "Forbes"), url: "part"),
        CustomData(title: "Time", image: #imageLiteral(resourceName: "Time"), url: "part"),
        CustomData(title: "RollingStone", image: #imageLiteral(resourceName: "RollingStone"), url: "part"),
        CustomData(title: "NatGeo", image: #imageLiteral(resourceName: "NatGeo"), url: "part"),
        CustomData(title: "Vogue", image: #imageLiteral(resourceName: "Vogue"), url: "part"),
        CustomData(title: "MensHealth", image: #imageLiteral(resourceName: "MensHealth"), url: "part"),
        CustomData(title: "Money", image: #imageLiteral(resourceName: "Money"), url: "part"),
        CustomData(title: "Source", image: #imageLiteral(resourceName: "Source"), url: "part"),
        CustomData(title: "Nylon", image: #imageLiteral(resourceName: "Nylon"), url: "part"),
        CustomData(title: "Fashion", image: #imageLiteral(resourceName: "Fashion"), url: "part"),
    ]
    
    // MARK: - Passed
    
    var urlToOpen: URL?
    
    // MARK: - Properties
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    // MARK: - Storyboard
    
    struct Storyboard {
        static let WebBrowserSegue = "WebSegue"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0).isActive = true
        
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.5).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self //Methods wont run if these arent called
        
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true

        imageView.sizeToFit()
        setupImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let browserVC = segue.destination as? WebBrowserViewController {
             browserVC.receivedLink = urlToOpen
         }
    }
    
    private func setupImage(){
        extractInfoFromURLs(url: "https://techcrunch.com/2014/02/19/facebook-buying-whatsapp-for-16b-in-cash-and-stock-plus-3b-in-rsus/")
    }
    
    
    func extractInfoFromURLs(url: String) {
        let articleUrl = URL(string: url)!
        Readability.parse(url: articleUrl, completion: { data in
            let title = data?.title ?? ""
            let description = data?.description ?? ""
            let keywords = data?.keywords ?? []
            let imageUrl = data?.topImage
            let videoUrl = data?.topVideo
            
            print("title: \(title), keywords \(keywords), top image: \(imageUrl), top video: \(videoUrl)")
            
            DispatchQueue.main.async {
                self.imageView.downloadImage(from: URL(string: "https://techcrunch.com/wp-content/uploads/2014/02/b0pjcuntzee4hgg07zt84ayv5q37uttg-rr1v3xj2lu.png")!)
                self.titleLbl.text = title
            }
        })
    }

}

extension NewsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        
        // Configure the cell
        // let part = partController.part[indexPath.item]
        cell.data = self.data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        urlToOpen = URL(string: "https://www.techmeme.com")
        performSegue(withIdentifier: "WebSegue", sender: indexPath)
        
        //performSegue(withIdentifier: "ViewNewsSegue", sender: indexPath)
    }
}

class CustomCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet{
            guard let data = data else {return}
            bg.image = data.image
        }
    }
    
    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Source")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
