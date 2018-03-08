//
//  imagesVC.swift
//  KipIt
//
//  Created by djepbarov on 31.12.2017.
//  Copyright © 2017 djepbarov. All rights reserved.
//

import UIKit
import Photos
import CoreData
class PhotosVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    var images = Images().image
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var managedObjectContext:NSManagedObjectContext?
    var titleOfAlbum = ""
    var photos = [Photos]()
    var userCollections: PHFetchResult<PHCollection>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        setCollectionView()
        loadData()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addPhoto))
        self.navigationItem.rightBarButtonItem = addButton
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
        navigationItem.title = titleOfAlbum
    }
    
    
    @objc func addPhoto(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.createPresentItem(with: image)
                self.collectionView.reloadData()
            })
        }
    }
    
    func createPresentItem (with image:UIImage) {
        
        let photo = Photos(context: managedObjectContext!)
        photo.image = NSData(data: UIImageJPEGRepresentation(image, 1)!) as Data
        photo.category_name = titleOfAlbum
        do {
            try self.managedObjectContext?.save()
            self.loadData()
        }catch {
            print("Could not save data \(error.localizedDescription)")
        }
    }
    
    func loadData(){
        let photoRequest:NSFetchRequest<Photos> = Photos.fetchRequest()

        do {
            photos = (try managedObjectContext?.fetch(photoRequest))!
            images.removeAll()
            for category in photos {
                if category.category_name == titleOfAlbum {
                    if let image = UIImage(data: category.image!) {
                            images.append(image)
                    }
                }
            }
            self.collectionView.reloadData()
        } catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
    }
    
}

extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotosCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func setCollectionView() {
        let itemSize = collectionView.frame.size.width / 2
        let layout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        layout.itemSize = CGSize(width: itemSize - 50, height: 200)
        //layout.minimumLineSpacing = 5
        //layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! PhotosCollectionViewCell
        imageView.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        view.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        imageView.image = selectedCell.imageView.image
        collectionView.allowsSelection = false
        navigationController?.navigationBar.isHidden = true
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imageView.removeFromSuperview()
        navigationController?.navigationBar.isHidden = false
        collectionView.allowsSelection = true
    }
}


extension PhotosVC : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
