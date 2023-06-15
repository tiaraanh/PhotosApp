//
//  PreviewViewController.swift
//  photosApp
//
//  Created by Tiara H on 13/06/23.
//

import UIKit

class PreviewViewController: UIViewController {
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var primaryView: UIView!
    @IBOutlet weak var secondaryView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    var selectedImage: UIImage!
    var selectedSortingOption: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.image = selectedImage
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        
        primaryView.backgroundColor = .black
        secondaryView.backgroundColor = .black
        thirdView.backgroundColor = .black
        
    }
}

// MARK: -UIScrollViewDelegate
extension PreviewViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.previewImageView
    }
}
