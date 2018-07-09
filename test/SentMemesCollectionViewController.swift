//
//  CollectionViewController.swift
//  test
//
//  Created by Mark Renker on 5/3/18.
//  Copyright © 2018 Fourier Ventures, LLC. All rights reserved.
//

import Foundation
import UIKit

//define struct for Meme

var memes: [Meme]! {
    let object = UIApplication.shared.delegate
    let appDelegate = object as! AppDelegate
    return appDelegate.memes
}

// MARK: - SentMemesCollectionViewController: UICollectionViewController

class SentMemesCollectionViewController: UICollectionViewController {
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var sentMemesCollectionView: UICollectionView!
    
    var memes : [Meme]!
    
    //consider placing in view did load
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        memes = appDelegate.memes
        
        //make sure everything sent memes up to date
        collectionView?.reloadData()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(self.memes.count)
        return self.memes.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.sentMemesImageView?.image = meme.memedImage
        
        print(self.memes.count)
        return cell
    }
    
    //populate the detail view
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemesDetailViewController") as! SentMemesDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.memes = self.memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}


