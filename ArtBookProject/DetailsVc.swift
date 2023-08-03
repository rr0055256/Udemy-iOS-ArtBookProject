//
//  DetailsVc.swift
//  ArtBookProject
//
//  Created by Raman Rajagopal on 03/08/23.
//

import UIKit
import CoreData

class DetailsVc: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var uiImageView: UIImageView!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var artistTextField: UITextField!
    
    
    @IBOutlet weak var yearTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        uiImageView.isUserInteractionEnabled = true
        
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        view.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    @objc func openImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uiImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    

    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        //attributes
        
        newPainting.setValue(nameTextField.text, forKey: "name")
        newPainting.set
    }
    
}
