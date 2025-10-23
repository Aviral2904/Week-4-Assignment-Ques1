//
//  DetailEditLaptopViewController.swift
//  ListOfLaptops
//
//  Created by Mishra, Aviral on 08/10/25.
//

import UIKit
import SVProgressHUD

class DetailEditLaptopViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private weak var laptopImageView: UIImageView!
    @IBOutlet private weak var modelNameTextField: UITextField!
    @IBOutlet private weak var brandTextField: UITextField!
    @IBOutlet private weak var ramTextField: UITextField!
    @IBOutlet private weak var storageTextField: UITextField!
    @IBOutlet private weak var graphicCardTextField: UITextField!
    
    
    var selectedLaptop: Laptop!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Laptop Details"
        
        modelNameTextField.text = selectedLaptop.modelName
        brandTextField.text = selectedLaptop.brand
        ramTextField.text = selectedLaptop.ram
        storageTextField.text = selectedLaptop.storage
        graphicCardTextField.text = selectedLaptop.graphicCard
        
        if let imageData = selectedLaptop.image {
            laptopImageView.image = UIImage(data: imageData)
            
        }
        
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
        
        selectedLaptop.modelName = modelNameTextField.text
        selectedLaptop.brand = brandTextField.text
        selectedLaptop.ram = ramTextField.text
        selectedLaptop.storage = storageTextField.text
        selectedLaptop.graphicCard = graphicCardTextField.text
        selectedLaptop.image = laptopImageView.image?.pngData()
        
        SVProgressHUD.show(withStatus: "Updating...")
        try? context.save()
        
        SVProgressHUD.showSuccess(withStatus: "Updated!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction private func deleteTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Laptop", message: "Are you sure?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            SVProgressHUD.show(withStatus: "Deleting...")
            self.context.delete(self.selectedLaptop)
            
            try? self.context.save()
            
            SVProgressHUD.showSuccess(withStatus: "Deleted!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.navigationController?.popViewController(animated: true)
            }
            
        }))
        present(alert, animated: true)
    }
    

    

}
