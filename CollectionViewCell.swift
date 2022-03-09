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

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!


    private func update(){
        if let url = imageURL{
            imageView.image = nil
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async { [self] in
                    if let imageData = urlContents, url == self.imageURL,
                        let image = UIImage(data: imageData) {
                        self.imageView?.image =  image
                    }
                    else {
                        //not a valid image
                        self.imageView.image = "😿".image()
                    }
                    self.spinner?.stopAnimating()
                }
            }
        }
    }

}
extension String {
    func image() -> UIImage? {
         let rect = CGRect(origin: CGPoint(), size: CGSize(width: 100, height: 100))
         return UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100)).image { (context) in
         (self as NSString).draw(in: rect, withAttributes: [.font : UIFont.systemFont(ofSize: 50)])
        }
    }
}
