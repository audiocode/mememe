//
//  SentMemesTableViewController.swift
//  test
//
//  Created by Mark Renker on 6/14/18.
//  Copyright © 2018 Fourier Ventures, LLC. All rights reserved.
//

import Foundation
import UIKit


class SentMemesTableViewController: UITableViewController {
    
    
    @IBOutlet var sentMemesTableView: UITableView!
    
    
    var memes: [Meme]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        memes = appDelegate.memes
        tableView.reloadData()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(self.memes.count)
        return self.memes.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        print(self.memes.count)
        return cell
        
    }
 
    //populate the detail view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Grab the SentMemesDetailViewController from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemesDetailViewController") as! SentMemesDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.memes = self.memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

}
