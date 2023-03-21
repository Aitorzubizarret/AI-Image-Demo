//
//  PetitionDetailViewController.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-20.
//

import UIKit

class PetitionDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var saveImageButton: UIButton!
    @IBAction func saveImageButtonTapped(_ sender: Any) {
        saveImage()
    }
    
    // MARK: - Properties (from PresenterToViewPetitionDetailProtocol)
    
    var presenter: ViewToPresenterPetitionDetailProtocol?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
    }
    
    // Saves the image displayed in the UIImageView in the Photo Gallery.
    private func saveImage() {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(savedImage), nil)
        } else {
            showErrorAlert(errorDescription: "No image found.")
        }
    }
    
    @objc func savedImage(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        if let error = error {
            showErrorAlert(errorDescription: error.localizedDescription)
        } else {
            showSuccessAlert()
        }
    }
    
}

// MARK: - Presenter To View Petition Detail Protocol

extension PetitionDetailViewController: PresenterToViewPetitionDetailProtocol {
    
    func onGetPetitionSuccess() {
        // TODO: Fix this
        if let imagesData: [Data] = presenter?.petitionImagesData(),
           let firstImage = imagesData.first {
            imageView.image = UIImage(data: firstImage)
        }
        errorDescriptionLabel.text = presenter?.petitionErrorDescription()
        descriptionLabel.text = presenter?.petitionDescription()
    }
    
    func onGetPetitionFailure(errorDescription: String) {
        print("")
    }
    
}

// MARK: - UIAlertController

extension PetitionDetailViewController {
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Success",
                                      message: "Photo saved in photo gallery",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func showErrorAlert(errorDescription: String) {
        let alert = UIAlertController(title: "Error",
                                      message: errorDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
}
