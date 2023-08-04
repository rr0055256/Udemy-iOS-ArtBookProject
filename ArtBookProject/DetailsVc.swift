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
    
    @IBOutlet weak var saveButton: UIButton!
    
    var chosenName = ""
    var chosenUuid : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        uiImageView.isUserInteractionEnabled = true
        
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        uiImageView.addGestureRecognizer(imageGestureRecognizer)
        
        if chosenName != "" {
            //fetch from coredata
            saveButton.isHidden = true
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let idString = chosenUuid?.uuidString
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            let predicate = NSPredicate(format: "id = %@", idString!)
            
            fetchRequest.predicate = predicate
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let name = result.value(forKey: "name") as? String {
                            nameTextField.text = name
                        }
                        
                        if let artist = result.value(forKey: "artist") as? String {
                            artistTextField.text = artist
                        }
                        
                        if let year = result.value(forKey: "year") as? Int {
                            yearTextField.text = String(year)
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            uiImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }catch{
                print("Error")
            }
        }else{
            nameTextField.text = ""
            artistTextField.text = ""
            yearTextField.text = ""
            saveButton.isHidden = false
            saveButton.isEnabled = false
        }
        
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
        saveButton.isEnabled = true
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    

    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        //attributes
        
        newPainting.setValue(nameTextField.text!, forKey: "name")
        newPainting.setValue(artistTextField.text!, forKey: "artist")
        
        if let year = Int(yearTextField.text!) {
            newPainting.setValue(year, forKey: "year")
        }
        
        newPainting.setValue(UUID(), forKey: "id")
        
        let data = uiImageView.image!.jpegData(compressionQuality: 0.5)
        
        newPainting.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("Success")
        }catch {
            print("Error")
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
