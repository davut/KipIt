//
//  MainSceneVC.swift
//  KipIt
//
//  Created by djepbarov on 27.12.2017.
//  Copyright © 2017 djepbarov. All rights reserved.
//

import UIKit
import CoreData
class MainSceneVC: UIViewController, UICollectionViewDelegateFlowLayout {
    var isMainKip = false
    @IBOutlet weak var collectionView: UICollectionView!
    var managedObjectContext: NSManagedObjectContext!
    var categories = [Categories]()
    var photos = [Photos]()
    var images = Images().image
    var last = UIImage()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        setCollectionView()
        loadData()
    }
    
    // Functions
    func loadData() {
        let requestCategory: NSFetchRequest<Categories> = Categories.fetchRequest()
        let requestPhotos: NSFetchRequest<Photos> = Photos.fetchRequest()
        do{
            photos = try managedObjectContext.fetch(requestPhotos)
            categories = try managedObjectContext.fetch(requestCategory)
            collectionView.reloadData()
        } catch {
            print("Couldnt fetch \(error.localizedDescription)")
        }
    }
    
    @objc func addAlbum(_ sender: AnyObject) {
        let alertController = UIAlertController(title: NSLocalizedString("New Album", comment: ""), message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("Album Name", comment: "")
        }
        
        alertController.addAction(UIAlertAction(title: "Create", style: .default) { action in
            let textField = alertController.textFields!.first!
            if let title = textField.text, !title.isEmpty {
                let collectionTitle = Categories(context: self.managedObjectContext)
                collectionTitle.category_name = title
                do {
                    try self.managedObjectContext.save()
                    self.loadData()
                }catch {
                    print("Could not save it \(error.localizedDescription)")
                }
                self.collectionView.reloadData()
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    @objc func settings() {
        performSegue(withIdentifier: "settingsScene", sender: nil)
    }
    
    func setNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addAlbum))
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.settings))
        self.navigationItem.leftBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem = settingsButton
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        navigationItem.title = "Albums"
    }
    
}

// Collection View
extension MainSceneVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StackCollectionViewCell
        for images in photos where images.category_name == categories[indexPath.row].category_name {
            if let image = UIImage(data: images.image!){
                last = image
            }
        }
        images.append(last)
        cell.imageView.image = images[indexPath.row]
        cell.collectionNameLbl.text = categories[indexPath.row].category_name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.performSegue(withIdentifier: "MainScene", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView.indexPath(for: cell) {
            let destionationVC = segue.destination as! PhotosVC
            destionationVC.titleOfAlbum = (categories[indexPath.row].category_name)!
        }
        
    }
    
    func setCollectionView() {
        let itemSize = collectionView.frame.size.width / 2
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        layout.itemSize = CGSize(width: itemSize - 50, height: 200)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
}
