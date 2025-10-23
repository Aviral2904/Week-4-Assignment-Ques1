//
//  AddLaptopViewController.swift
//  ListOfLaptops
//
//  Created by Mishra, Aviral on 08/10/25.
//

import UIKit
import SVProgressHUD

class AddLaptopViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet private weak var laptopImageView: UIImageView!
    @IBOutlet private weak var modelNameTextField: UITextField!
    @IBOutlet private weak var brandTextField: UITextField!
    @IBOutlet private weak var ramTextField: UITextField!
    @IBOutlet private weak var storageTextField: UITextField!
    @IBOutlet private weak var graphicCardTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Laptop"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        
        laptopImageView.isUserInteractionEnabled = true
        laptopImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageViewTapped() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            laptopImageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    @IBAction private func saveTapped(_ sender: Any) {
        guard let modelName = modelNameTextField.text, !modelName.isEmpty, let brand = brandTextField.text, !brand.isEmpty, laptopImageView.image != nil else {
            let alert = UIAlertController(title: "Missing Info", message: "Model, Brand and image are required", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(alert, animated: true)
            return
            }
        
        SVProgressHUD.show(withStatus: "Saving...")
        let newLaptop = Laptop(context: context)
        
        newLaptop.id = UUID()
        newLaptop.modelName = modelName
        newLaptop.brand = brand
        newLaptop.ram = ramTextField.text
        newLaptop.storage = storageTextField.text
        newLaptop.graphicCard = graphicCardTextField.text
        newLaptop.image = laptopImageView.image?.pngData()
        
        try? context.save()
        
        SVProgressHUD.showSuccess(withStatus: "Saved!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            
            self.navigationController?.popViewController(animated: true)
        }
    }

}
