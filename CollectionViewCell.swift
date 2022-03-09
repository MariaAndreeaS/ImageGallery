//
//  CollectionViewCell.swift
//  ImageGallery
//
//  Created by Maria Andreea on 07.03.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    var imageURL: URL?
    {
        didSet{
            update()
        }
    }
    var changeAspectRatio : (() -> Void)?

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!


    private func update(){
        if let url = imageURL{
            imageView.image = nil
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self.imageURL,
                        let image = UIImage(data: imageData) {
                        self.imageView?.image =  image
                    }
                    self.spinner?.stopAnimating()
                }
            }
        }
    }
}
