//
//  GalleryViewModel.swift
//  photosApp
//
//  Created by Tiara H on 13/06/23.
//

import Foundation

class GalleryViewModel {
    var dataImage: [PhotoGallery]?
    
    // Grouping options for segmented control
    enum GroupingOption: Int {
        case allPhotos
        case byYear
        case byMonth
        case byDay
    }
    
    var currentGroupingOption: GroupingOption = .allPhotos
    
    func groupPhotosByDate() {
        guard let images = dataImage else {
            return
        }
        
        switch currentGroupingOption {
        case .allPhotos:
            // No grouping, show all photos
            break
            
        case .byYear:
            // Group photos by year
            let groupedImages = Dictionary(grouping: images) { (photo) -> String in
                let year = Calendar.current.component(.year, from: photo.addedAt!)
                return "\(year)"
            }
            
            // Update dataImage with grouped images
            dataImage = groupedImages.values.flatMap { $0 }
        case .byMonth:
            // Group photos by month and year
            let groupedImages = Dictionary(grouping: images) { (photo) -> String in
                let year = Calendar.current.component(.year, from: photo.addedAt!)
                let month = Calendar.current.component(.month, from: photo.addedAt!)
                return "\(year)-\(month)"
            }
            
            // Update dataImage with grouped images
            dataImage = groupedImages.values.flatMap { $0 }
        case .byDay:
            // Group photos by day, month, and year
            let groupedImages = Dictionary(grouping: images) { (photo) -> String in
                let year = Calendar.current.component(.year, from: photo.addedAt!)
                let month = Calendar.current.component(.month, from: photo.addedAt!)
                let day = Calendar.current.component(.day, from: photo.addedAt!)
                return "\(year)-\(month)-\(day)"
            }
            
            // Update dataImage with grouped images
            dataImage = groupedImages.values.flatMap { $0 }
        }
    }
}
