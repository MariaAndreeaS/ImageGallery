//
//  CollectionViewController.swift
//  ImageGallery
//
//  Created by Maria Andreea on 08.03.2022.
//

import UIKit


class CollectionViewController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate{

    struct Image{
        var url : URL //url of image
        var aspectRatio: Double
    }

    //array of images
    var imageCollection = [Image]()

    var aspRatio: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.dropDelegate = self
        collectionView!.dragDelegate = self
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the number of items
        return imageCollection.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)

        // Configure the cell
        if let cellImage = cell as? CollectionViewCell {
            cellImage.imageURL = imageCollection[indexPath.item].url
        }
        return cell
    }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let imgWidth = 100.0
        let imgHeight = CGFloat(imageCollection[indexPath.item].aspectRatio)
        return CGSize(width: imgWidth, height: imgWidth/imgHeight )
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragImages(at: indexPath)
    }

    func dragImages(at indexPath: IndexPath) -> [UIDragItem] {
         if let imageGallery = (collectionView?.cellForItem(at: indexPath) as? CollectionViewCell)?.imageURL {
            let dragImage = UIDragItem(itemProvider: NSItemProvider(object: imageGallery as NSItemProviderWriting))
                dragImage.localObject = dragImage
                return [dragImage]
        }
      return []
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = "Show Image"
        if segue.identifier != nil {
               if let imageCell = sender as? CollectionViewCell,
                   let indexPath = collectionView?.indexPath(for: imageCell),
                   let image = segue.destination as? ImageViewController {
                        image.imageURL = imageCollection[indexPath.item].url
                }
            }
        }

    //drop data into the collection view
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {

        let indexDestination = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
           let items = coordinator.items
            for item in items {
                if let sourceIndexPath = item.sourceIndexPath{
                collectionView.performBatchUpdates({
                    let moveImage = imageCollection[sourceIndexPath.item]
                    imageCollection.remove(at: sourceIndexPath.item)
                    imageCollection.insert(moveImage, at: indexDestination.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [indexDestination])
                })
                coordinator.drop(item.dragItem, toItemAt: indexDestination)
            }
           else {

            let placeholderContext = coordinator.drop( item.dragItem,
                to: UICollectionViewDropPlaceholder(insertionIndexPath: indexDestination, reuseIdentifier: "Drop"
                     )
                 )

                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) {(data, error) in
                    DispatchQueue.main.async {
                        if let image = data as? UIImage {
                            self.aspRatio = Double(image.size.width / image.size.height)
                        }
                    }
                }

                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (data, error) in
                    DispatchQueue.main.async {
                        if let url = data as? URL {
                            placeholderContext.commitInsertion(dataSourceUpdates:{ insertionIndexPath in
                                self.imageCollection.insert(Image(url: url.imageURL, aspectRatio: self.aspRatio!),
                                    at: insertionIndexPath.item)
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
           }
       }
    }
}
