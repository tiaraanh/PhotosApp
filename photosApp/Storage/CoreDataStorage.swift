//
//  CoreDataStorage.swift
//  photosApp
//
//  Created by Tiara H on 14/06/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataStorage {
    static let shared: CoreDataStorage = CoreDataStorage()
    private init() {
        printCoreDataDBPath()
    }
    
    // context persistent container
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // print for core data path
    private func printCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print("Core Data DB Path :: \(path ?? "Not found")")
    }
    
    // fetch image
    func fetchImage() -> ([PhotoGallery]?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoGallery")
        do {
            let retrieveData = try context.fetch(fetchRequest) as? [PhotoGallery]
            return retrieveData
        } catch {
            print("Error while fetching data: \(error)")
        }
        return nil
    }
    
    // add Image
    func addImage(image: UIImage?, date: Date) {
        guard let entity = NSEntityDescription.entity(forEntityName: "PhotoGallery", in: context) else {
            fatalError("Error while fetching entity")
        }
        
        // convert UIIMAGE to Data
        let photoGallery = PhotoGallery(entity: entity, insertInto: context)
        var imageData: Data? {
            if let images = image {
                return images.jpegData(compressionQuality: 1)
            } else {
                return nil
            }
        }
        
        print("data added: \(String(describing: image))")
        photoGallery.savedImage = imageData
        photoGallery.addedAt = date
    }
    
    // delete image
    func deleteImage() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoGallery")
        do {
            guard let result = try context.fetch(fetchRequest) as? [PhotoGallery] else {
                fatalError("error in retrieve data")
            }
            
            for item in result {
                context.delete(item)
          }
            
        } catch {
            print("errror fetcing while delete image: \(error)")
        }
    }
    
    // update image
    func updateImage(image: UIImage?, date: Date) {
        let fetchRequset = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoGallery")
        do {
            let result = try context.fetch(fetchRequset) as! [PhotoGallery]
            print(result.count)
            
            if result.count == 1 {
                if let image = image {
                    result[0].savedImage = image.jpegData(compressionQuality: 1 )
                }
                
                result[0].addedAt = date
            } else if result.isEmpty {
                addImage(image: image, date: date)
            }
        } catch {
            print("fetching error for update")
        }
    }
}
