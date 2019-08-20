//
//  PhotosCollectionViewController.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import UIKit

final class PhotosCollectionViewController: UICollectionViewController {
  
  // MARK: - Properties
  @IBOutlet weak var textField: UITextField!
  private let collectionViewNumberOfSections = 1
  private let reuseIdentifier = "PhotoCell"
  private let sectionInsets = UIEdgeInsets(top: 15.0, left: 20.0, bottom: 15.0, right: 20.0)
  private let itemsPerRow: CGFloat = 3
  
  // FlickrImageService is used here only, so if a new service like Tumblr is required in the future, only this single line of code needs to change to adapt.
  private var viewModel = PhotosViewModel(imageService: FlickrImageService(networkService: NetworkService()))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textField.becomeFirstResponder()
  }

  // Adds new cells when user has scrolled to the bottom and new data is fetched.
  func addSearchResults(_ imagesCount: ImagesCount) {
    let firstIndex = imagesCount.totalImages - imagesCount.addedImages
    var addedIndexPaths = [IndexPath]()
    for i in firstIndex..<imagesCount.totalImages {
      addedIndexPaths.append(IndexPath(row: i, section: 0))
    }
    DispatchQueue.main.async {
      self.collectionView.performBatchUpdates({ [unowned self] in
        self.collectionView.insertItems(at: addedIndexPaths)
        }, completion: nil)
    }
  }
  
}


// MARK: - Text Field Delegate
extension PhotosCollectionViewController : UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    textField.addSubview(activityIndicator)
    activityIndicator.frame = textField.bounds
    activityIndicator.startAnimating()
    textField.placeholder = ""
    
    // Search for the query user has typed
    viewModel.search(for: textField.text!) { [weak self] result in
      guard let self = self else {
        return
      }
      DispatchQueue.main.async {
        activityIndicator.removeFromSuperview()
        textField.placeholder = "Search photos..."
      }
      switch result {
      case .success( _):

        DispatchQueue.main.async {
          self.collectionView.performBatchUpdates({ [self] in
            self.collectionView.reloadSections([0])
            }, completion: { _ in
              if self.collectionView.numberOfItems(inSection: 0) > 0 {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
              }
          })
        }
      case .error(let error):
        DispatchQueue.main.async {
          self.alertMessage(error)
        }
      }
    }
    textField.text = nil
    textField.resignFirstResponder()
    return true
  }
}

// MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController {

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return collectionViewNumberOfSections
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    if viewModel.imageUrls.count == 0 {
      collectionView.setEmptyMessage("Nothing here! \n Search using the search field above 🔎")
    }
    else {
      collectionView.restore()
    }
    return viewModel.imageUrls.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCell else {
      return UICollectionViewCell()
    }
    
    guard let url = viewModel.imageUrls[safe: indexPath.row] else {
      return cell
    }
    
    cell.update(with: UIImage.colorImage(.init(red: 0, green: 0, blue: 0, alpha: 0.1), size: CGSize(width: 100, height: 100)))
    cell.enableLoading()
    
    let expectedCellTag = cell.tag
    
    viewModel.getImage(for: url) { [weak cell] result in
      switch result {
      case .success(let image):
        if expectedCellTag == cell?.tag {
          // To avoid conflicting dequeued cells that causes replacing cells in wrong order while scrolling,
          // a random tag is assigned to each cell and updated each time the cell is reused.
          cell?.update(with: image)
        }
      case .error(let error):
        print("Error: \(error)")
      }
    }

    return cell
  }
  
  // willDisplay here is used to check if the displayed cell is the last cell and if so, fetches new data.
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == viewModel.imageUrls.count - 1 {
      viewModel.fetchMoreResults { [weak self] result in
        switch result {
        case .success(let imagesCount):
          self?.addSearchResults(imagesCount)
        case .error(let error):
          DispatchQueue.main.async {
            self?.alertMessage(error)
          }
        }
      }
      
    }
  }

}

// MARK: - Collection View Flow Layout Delegate
extension PhotosCollectionViewController : UICollectionViewDelegateFlowLayout {
  
  // A simple layout for collection view cells to display nicely on all devices (and to easily adopt fullscreen mode as mentioned on the assignment).
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
  
}
