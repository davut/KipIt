//
//  imagesVC.swift
//  KipIt
//
//  Created by djepbarov on 31.12.2017.
//  Copyright © 2017 djepbarov. All rights reserved.
//

import UIKit
import Photos

class PhotosVC: UIViewController {
   
    var titleOfAlbum = ""
    var userCollections: PHFetchResult<PHCollection>!
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addAlbum))
        self.navigationItem.rightBarButtonItem = addButton
        // Do any additional setup after loading the view.
    }

    @objc func addAlbum(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: NSLocalizedString("New Album", comment: ""), message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("Album Name", comment: "")
        }
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Create", comment: ""), style: .default) { action in
            let textField = alertController.textFields!.first!
            if let title = textField.text, !title.isEmpty {
                // Create a new album with the title entered.
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                }, completionHandler: { success, error in
                    if !success { print("error creating album: \(error)") }
                })
            }
        })
        self.present(alertController, animated: true, completion: nil)
    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return userCollections.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return
//    }

}
    
