//
//  AIImageTableViewCell.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-06.
//

import UIKit

class AIImageTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var artificialImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var botomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    var isWaiting: Bool = false {
        didSet {
            if isWaiting {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                artificialImageView.image = UIImage()
            } else {
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
            }
        }
    }
    var aiImageData: Data? {
        didSet {
            if let aiImageData = aiImageData {
                artificialImageView.image = UIImage(data: aiImageData)
            }
        }
    }
    var descriptionText: String = "" {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    var errorText: String = "" {
        didSet {
            if !errorText.isEmpty {
                errorLabel.isHidden = false
                errorLabel.text = errorText
            } else {
                errorLabel.isHidden = true
            }
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        selectionStyle = .none
        
        artificialImageView.image = UIImage()
        activityIndicator.isHidden = true
        errorLabel.isHidden = true
    }
    
}
