//
//  ViewController.swift
//  Project1
//
//  Created by Ana Caroline de Souza on 11/12/19.
//  Copyright © 2019 Ana e Leo Corp. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    var picturesLabels = [String]()
    var pictureTimesShown = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viwer Da Massa"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let defaults = UserDefaults.standard
         if let pictureTimesShownFromUserDefaults = defaults.object(forKey: "timesShown") as? Data {
             let jsonDecoder = JSONDecoder()
             do {
                 pictureTimesShown = try jsonDecoder.decode([Int].self, from: pictureTimesShownFromUserDefaults)
             } catch {
                 print("errrroooorr")
             }
         }
        
        performSelector(inBackground: #selector(loadImagesListFromBundle), with: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareTapped))
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictureTimesShown) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "timesShown")
        } else {
            print("We failed to save the array")
        }
    }
    
    @objc func loadImagesListFromBundle() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        let pictureShownEmpty = pictureTimesShown.isEmpty

        
        let itemsFilteredSorted = items.filter({$0.hasPrefix("nssl")}).sorted()
        for (index, item) in itemsFilteredSorted.enumerated() {
            picturesLabels.append("Picture \(index+1) of \(itemsFilteredSorted.count)")
            pictures.append(item)
            if pictureShownEmpty {
                pictureTimesShown.append(0)
            }
        }
        
        DispatchQueue.main.async {
          [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = picturesLabels[indexPath.row]
        return cell       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            pictureTimesShown[indexPath.row] += 1
            vc.pictureTimesShown = pictureTimesShown[indexPath.row]
            save()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func shareTapped(){
        let recommendationMessage = "Yeah, i definitely recommend this app, you should try now!"
        let vc = UIActivityViewController(activityItems: [recommendationMessage], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated:true)
    }
    
}

