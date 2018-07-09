//
//  ViewController.swift
//  test
//
//  Created by Mark Renker on 3/1/18.
//  Copyright © 2018 Fourier Ventures, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem?
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerToolbar: UIToolbar!
    @IBOutlet weak var shareToolbar: UIToolbar!
    var memedImage: UIImage!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //configure top and bottom text
        configure(textField: topTextField, text: "TOP")
        configure(textField: bottomTextField, text: "BOTTOM")
        
        shareButton?.isEnabled = false
    
    }
    
    
    func configure(textField: UITextField, text: String){
        
        textField.text = text
        
        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: NSNumber(value: -3.0)
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        
        textField.textAlignment = .center
        
        //set text field delegate
        topTextField.delegate = self
        bottomTextField.delegate = self
        
    }
    
    @IBAction func topTextField(_ sender: Any) {
        
        //text clears when user taps text field
        self.topTextField.text = ""
        
    }
    
    @IBAction func bottomTextField(_ sender: Any) {
        
        self.bottomTextField.text = ""
        
    }
    
    //keep status bar hidden
    override var prefersStatusBarHidden: Bool {
        
        return true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
 
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    //hide keyboard when return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        //displace original view by height of the keyboard
        if bottomTextField.isFirstResponder {
            
            // move up
            view.frame.origin.y = -getKeyboardHeight(notification)
            
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
        
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        //set screen back to original position
        view.frame.origin.y = 0
        
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        presentImagePickerWith(sourceType: .photoLibrary)
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        presentImagePickerWith(sourceType: .camera)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        imagePickerView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        shareButton?.isEnabled = true
        
    }

     func hideToolbars(_ hide: Bool){
        
        // TODO: Hide toolbar and navbar.
        imagePickerToolbar!.isHidden = hide
        shareToolbar!.isHidden = hide
        
    }

    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar.
        self.hideToolbars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        self.hideToolbars(false)
        
        return memedImage
    }
    
    func save() {
        
        // Create the meme
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        
        // TODO: define an instance of the ActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        navigationController?.present(activityViewController, animated: true)
        
        // TODO: pass the ActivityViewController a memedImage as an activity item
        activityViewController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        // TODO: present the ActivityViewController
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        
        //set parameters for original view
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        
    }
    
}


