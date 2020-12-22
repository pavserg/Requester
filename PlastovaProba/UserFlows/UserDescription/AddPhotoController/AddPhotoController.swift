//
//  AddPhotoController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 22.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import FirebaseStorage


class AddPhotoController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var photoPlaceholderView: UIView!
    @IBOutlet weak var choosePhotoLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    
    private var photoPicker: PhotoPickerPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        setupPhotoPicker()
        setupUI()
        if let unwrappedPhotoUrl = UserImageHelper.shared.profileImageUrl {
            photoImageView.downloadImage(url: unwrappedPhotoUrl)
        }
    }
    
    private func setupUI() {
        titleLabel.text = "Хочемо тебе побачити".localized
        titleLabel.font = AppFonts.monteseratBold24
        subtitleLabel.text = "Додай своє якісне фото, бажано в однострої. Ти завжди зможеш змінити його пізніше.".localized
        subtitleLabel.font = AppFonts.monteserat18
        choosePhotoLabel.text = "Обрати фото".localized
        choosePhotoLabel.textColor = AppColors.green
      
        continueButton.backgroundColor = AppColors.green
        continueButton.layer.cornerRadius = 8.0
        continueButton.setTitleColor(AppColors.white, for: .normal)
        continueButton.setTitle("onboarding_next".localized, for: .normal)
        photoPlaceholderView.layer.cornerRadius = photoPlaceholderView.bounds.width/2
        photoPlaceholderView.clipsToBounds = true
    }
    
    private func setupPhotoPicker() {
        photoPicker = PhotoPickerPresenter(self, completionClosure: { (data) in
            if let unwrappedData = data {
                DispatchQueue.main.async {
                    
                    self.uploadImage(data: unwrappedData)
                    self.photoImageView.image = UIImage.init(data: unwrappedData)
                }
            }
        })
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        photoPicker?.present()
    }
    
    func uploadImage(data: Data) {
        guard let id = Scout.currentUser?.id else { return }
        let storageRef = Storage.storage().reference().child("\(id).png")
        storageRef.putData(data, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                
            } else {
                storageRef.downloadURL(completion: { (url, error) in
                    if error == nil {
                        if let newUrl = url?.absoluteString {
                            UserImageHelper.shared.profileImageUrl = newUrl
                        }
                    }
                })
            }
        })
    }
}
