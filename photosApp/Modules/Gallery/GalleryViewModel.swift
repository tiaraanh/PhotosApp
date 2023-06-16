//
//  GalleryViewModel.swift
//  photosApp
//
//  Created by Tiara H on 13/06/23.
//

import Foundation

class GalleryViewModel {
    var dataImage: [PhotoGallery]?
    var sectionDates: [Date] = []
    
    // grouping options for segmented control
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
            // no group, show all photos
            break
            
        case .byYear:
            // group photos by year
            let groupedImages = Dictionary(grouping: images) { (photo) -> String in
                let year = Calendar.current.component(.year, from: photo.addedAt!)
                return "\(year)"
            }
            
            // update dataImage
            dataImage = groupedImages.values.flatMap { $0 }
            
        case .byMonth:
            // group photos by month and year
            let groupedImages = Dictionary(grouping: images) { (photo) -> String in
                let year = Calendar.current.component(.year, from: photo.addedAt!)
                let month = Calendar.current.component(.month, from: photo.addedAt!)
                return "\(year)-\(month)"
            }
            
            dataImage = groupedImages.values.flatMap { $0 }
            
        case .byDay:
            // group photos by day, month, and year
            let groupedImages = Dictionary(grouping: images) { (photo) -> String in
                let year = Calendar.current.component(.year, from: photo.addedAt!)
                let month = Calendar.current.component(.month, from: photo.addedAt!)
                let day = Calendar.current.component(.day, from: photo.addedAt!)
                return "\(year)-\(month)-\(day)"
            }
            
            dataImage = groupedImages.values.flatMap { $0 }
        }
    }
}
