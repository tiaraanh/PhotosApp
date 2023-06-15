//
//  GalleryViewController.swift
//  photosApp
//
//  Created by Tiara H on 13/06/23.
//

import UIKit
import Photos
import PhotosUI

class GalleryViewController: UIViewController  {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let inset: CGFloat = 0
    private let spacing: CGFloat = 0
    
    var galleryViewModel = GalleryViewModel()
    var groupedDataImage: [[PhotoGallery]]?
    var images: [UIImage] = []
    
    var selectedSortingOption: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        
        // select the "All Photos"
        segmentedControl.selectedSegmentIndex = 3
        
        // action method to trigger the grouping
        segmentedControlButtonTapped(segmentedControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateFetchData()
        collectionView.reloadData()
    }
    
    //MARK: -FUNCTION
    func setup() {
        title = "Photos"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        collectionViewLayout.minimumLineSpacing = spacing
        collectionViewLayout.minimumInteritemSpacing = spacing
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = collectionViewLayout
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    //MARK: -ACTION
    
    // delete button
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point) {
                showDeleteConfirmation(for: indexPath)
            }
        }
    }
    
    func showDeleteConfirmation(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteImage(at: indexPath)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteImage(at indexPath: IndexPath) {
        guard let data = galleryViewModel.dataImage?[indexPath.item] else {
            return
        }
        CoreDataStorage.shared.context.delete(data)
        try? CoreDataStorage.shared.context.save()
        
        galleryViewModel.dataImage?.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
    
    // add button
    @IBAction func addButtonTapped(_ sender: Any) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 0
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // sort button
    @IBAction func sortButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Sort by", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Latest Added", style: .default, handler: { (UIAlertAction) in
            self.selectedSortingOption = 0
            self.sortImagesByLatest()
        }))
        alert.addAction(UIAlertAction(title: "Oldest Added", style: .default, handler: { (UIAlertAction) in
            self.selectedSortingOption = 1
            self.sortImagesByOldest()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true)
    }
    
    func sortImagesByLatest() {
        guard var images = galleryViewModel.dataImage else {
            return
        }
        images.sort { (photo1, photo2) -> Bool in
            if let date1 = photo1.addedAt, let date2 = photo2.addedAt {
                return date1 > date2
            }
            return false
        }
        galleryViewModel.dataImage = images
        collectionView.reloadData()
    }
    
    func sortImagesByOldest() {
        guard var images = galleryViewModel.dataImage else {
            return
        }
        images.sort { (photo1, photo2) -> Bool in
            if let date1 = photo1.addedAt, let date2 = photo2.addedAt {
                return date1 < date2
            }
            return false
        }
        galleryViewModel.dataImage = images
        collectionView.reloadData()
    }
    
    // segmented control button
    @IBAction func segmentedControlButtonTapped(_ sender: UISegmentedControl) {
        galleryViewModel.currentGroupingOption = GalleryViewModel.GroupingOption(rawValue: sender.selectedSegmentIndex) ?? .allPhotos
                groupPhotosByDate()
    }
    
    func groupPhotosByDate() {
            galleryViewModel.groupPhotosByDate()
            collectionView.reloadData()
        }
}

//MARK: -PHPickerViewControllerDelegate
extension GalleryViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    if let image = image as? UIImage {
                        
                        CoreDataStorage.shared.addImage(image: image, date: Date())
                        try? CoreDataStorage.shared.context.save()
                        print("data: \(image)")
                        
                        DispatchQueue.main.async {
                            self?.updateFetchData()
                            self?.collectionView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
}

//MARK: -UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = galleryViewModel.dataImage?.count {
            if count == 0 {
                return 1
            } else {
                return count
            }
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewCell.cellIdentifier, for: indexPath) as! GalleryViewCell
        
        if let count = galleryViewModel.dataImage?.count, count != 0 {
            let data = galleryViewModel.dataImage?[indexPath.item]
            print(indexPath.item)
            
            if let image = data?.savedImage{
                cell.thumbImageView.image = UIImage(data: image)
            }else{
                cell.thumbImageView.image = UIImage(named: "defaultImage")
            }
            
            if let name = data?.savedImage {
                print("cell \(name)")
            }
        }
        
        let width = floor((UIScreen.main.bounds.width - (inset * 3) - spacing) / 3)
        cell.widthConstraint.constant = width
        let height = floor((UIScreen.main.bounds.height - (inset * 6) - spacing) / 6)
        cell.heightConstraint.constant = height
        cell.setNeedsLayout()
        
        return cell
    }
    
}
//MARK: -UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "previewId") as! PreviewViewController
        
        if let count = galleryViewModel.dataImage?.count, count != 0 {
            let data = galleryViewModel.dataImage?[indexPath.item]
            if let image = data?.savedImage {
                viewController.selectedImage = UIImage(data: image)
            } else {
                viewController.selectedImage = UIImage(named: "defaultImage")
            }
        }
        
        viewController.selectedSortingOption = selectedSortingOption
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // fetch data
    func updateFetchData() {
        galleryViewModel.dataImage = CoreDataStorage.shared.fetchImage()?.sorted(by: { (photo1, photo2) -> Bool in
            if let date1 = photo1.addedAt, let date2 = photo2.addedAt {
                if selectedSortingOption == 0 {
                    return date1 > date2 // Sort by latest added
                } else {
                    return date1 < date2 // Sort by oldest added
                }
            }
            return false
        })
        collectionView.reloadData()
    }
}



