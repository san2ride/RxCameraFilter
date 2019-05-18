//
//  CameraFilterController.swift
//  RxCamera
//
//  Created by Jason Sanchez on 5/17/19.
//  Copyright © 2019 Jason Sanchez. All rights reserved.
//

import UIKit
import RxSwift

class CameraFilterController: UIViewController {

    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
            let photoCVC = navC.viewControllers.first as? PhotosController else {
                fatalError("Segue destination is not found")
        }
        
        photoCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
            self?.photoImageView.image = photo
        }).disposed(by: bag)
    }
    
    @IBAction func applyFilterButtonPressed() {
        
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: bag)
        
//        FilterService().applyFilter(to: sourceImage) { filteredImage in
//
//            DispatchQueue.main.async {
//                self.photoImageView.image = filteredImage
//            }
//        }
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false 
    }
}
