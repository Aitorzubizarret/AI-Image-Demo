//
//  PetitionTableViewCell.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-13.
//

import UIKit

protocol PetitionCellDelegate {
    func selectPetition(row: Int)
}

class PetitionTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var technologyIconImageView: UIImageView!
    @IBOutlet weak var technologyNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var petitionDescriptionLabel: UILabel!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    var petitionIsLoading: Bool = false {
        didSet {
            if petitionIsLoading {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            } else {
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
            }
        }
    }
    var petitionImagesData: [Data] = [] {
        didSet {
            if petitionImagesData.count > 1 {
                pageControl.isHidden = false
                pageControl.numberOfPages = petitionImagesData.count
                pageControlCurrentPage = 0
            } else {
                pageControl.isHidden = true
            }
            
            collectionView.reloadData()
        }
    }
    var petitionHasErrorDescription: Bool = false {
        didSet {
            if petitionHasErrorDescription {
                errorDescriptionLabel.isHidden = false
            } else {
                errorDescriptionLabel.isHidden = true
            }
        }
    }
    var petitionErrorDescription: String = "" {
        didSet {
            errorDescriptionLabel.text = petitionErrorDescription
        }
    }
    var petitionDescription: String = "" {
        didSet {
            petitionDescriptionLabel.text = petitionDescription
        }
    }
    
    private var pageControlCurrentPage: Int = 0 {
        didSet {
            pageControl.currentPage = pageControlCurrentPage
        }
    }
    var delegate: PetitionCellDelegate?
    var row: Int?
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        // Technology Name.
        technologyNameLabel.text = "OpenAI - DALL·E"
        
        setupCollectionView()
        setupBottomLineImageView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = true
        
        // Layout.
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        
        // Register cell.
        let petitionImagecell = UINib(nibName: "PetitionImageCollectionViewCell", bundle: nil)
        collectionView.register(petitionImagecell, forCellWithReuseIdentifier: "PetitionImageCollectionViewCell")
    }
    
    private func setupBottomLineImageView() {
        bottomLineImageView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
    }
    
}

// MARK: - UICollectionView Delegate

extension PetitionTableViewCell: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleCellsIndexes: [IndexPath] = collectionView.indexPathsForVisibleItems

        if visibleCellsIndexes.count == 1,
           let firstIndexPath = visibleCellsIndexes.first {
            pageControlCurrentPage = firstIndexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate,
              let row = row else { return }
        
        delegate.selectPetition(row: row)
    }
    
}

// MARK: - UICollectionView Data Source

extension PetitionTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petitionImagesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetitionImageCollectionViewCell", for: indexPath) as! PetitionImageCollectionViewCell
        
        cell.petitionImageData = petitionImagesData[indexPath.row]
        
        return cell
    }
    
}

extension PetitionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = CGFloat(collectionView.frame.width)
        let cellHeight: CGFloat = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
