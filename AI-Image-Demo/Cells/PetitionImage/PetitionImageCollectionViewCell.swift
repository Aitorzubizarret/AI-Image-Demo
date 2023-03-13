//
//  PetitionImageCollectionViewCell.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-13.
//

import UIKit

class PetitionImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    var petitionImageData: Data? {
        didSet {
            guard let petitionImageData = petitionImageData else { return }
            
            imageView.image = UIImage(data: petitionImageData)
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
