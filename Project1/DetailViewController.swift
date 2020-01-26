//
//  DetailViewController.swift
//  Project1
//
//  Created by Ana Caroline de Souza on 12/12/19.
//  Copyright © 2019 Ana e Leo Corp. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var pictureTimesShown: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        title = "times show: \(pictureTimesShown!)"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @objc func shareTapped(){
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else
        {
            print("no image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image,selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem =
            navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
