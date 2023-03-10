//
//  ImageDetailViewController.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-10.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageErrorDescriptionLabel: UILabel!
    @IBOutlet weak var imageDescriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var petition: Petition
    
    // MARK: - Methods
    
    init(petition: Petition) {
        self.petition = petition
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        // ImageView
        if let imageData = petition.imageData {
            imageView.image = UIImage(data: imageData)
        }
        
        // Labels
        if let imageErrorDescription = petition.errorDescription {
            imageErrorDescriptionLabel.text = imageErrorDescription
        }
        
        if let imageDescription = petition.imageDescription {
            imageDescriptionLabel.text = imageDescription
        }
    }
    
}
