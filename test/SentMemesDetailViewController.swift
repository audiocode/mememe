//
//  SentMemesDetailViewController.swift
//  test
//
//  Created by Mark Renker on 6/19/18.
//  Copyright © 2018 Fourier Ventures, LLC. All rights reserved.
//

import Foundation
import UIKit


class SentMemesDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var memes: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.imageView!.image = memes.memedImage
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

 
}
