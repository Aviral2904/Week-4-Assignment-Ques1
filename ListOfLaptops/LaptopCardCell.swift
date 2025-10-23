//
//  LaptopCardCell.swift
//  ListOfLaptops
//
//  Created by Mishra, Aviral on 15/10/25.
//

import UIKit

class LaptopCardCell: UITableViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var laptopImageView: UIImageView!
    @IBOutlet private weak var modelNameLabel: UILabel!
    @IBOutlet private weak var brandLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowRadius = 5
        
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowColor = UIColor.black.cgColor
        
        laptopImageView.layer.cornerRadius = 8
        laptopImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with laptop: Laptop) {
        modelNameLabel.text = laptop.modelName
        brandLabel.text = laptop.brand
        if let imageData = laptop.image{
            laptopImageView.image = UIImage(data: imageData)
        } else{
            laptopImageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        }
        
    }
    
}
