//
//  ImageViewController.swift
//  ImageGallery
//
//  Created by Maria Andreea on 07.03.2022.
//

import UIKit

class ImageViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate {

    var imageView  = UIImageView()

    @IBOutlet weak var scrollView: UIScrollView!{
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addInteraction(UIDropInteraction(delegate: self))
    }


    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        if imageView.image == nil {
            fetch()
        }
    }

    private var image: UIImage?{
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }

      var imageURL: URL? {
            didSet {
                image = nil
                if view.window != nil {
                    fetch()
                }
          }
      }
    
      func fetch() {
          if let url = imageURL {
           DispatchQueue.global(qos: .userInitiated).async { [weak self] in
               if (try? Data(contentsOf: url.imageURL)) != nil {
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)}
                }
             }
           }
         }
       }
}

