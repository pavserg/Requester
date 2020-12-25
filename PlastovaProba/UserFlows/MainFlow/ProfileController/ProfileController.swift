//
//  ProfileController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 22.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileController: UIViewController {
    
    @IBOutlet weak var userInfoView: UserInfoView!

    //Mark: - band info
    @IBOutlet weak var bandPlaceholderView: UIView!
    @IBOutlet weak var bandTitleLabel: UILabel!
    @IBOutlet weak var symphatizerLabel: UILabel!
    @IBOutlet weak var firstChallengeLabel: UILabel!
    @IBOutlet weak var secondChallengeLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    var bandModel: BandModel?
    var challengePoints: [String: Bool]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        setupSettingButton()
        setupBandView()
        if let unwrapped = challengePoints {
            userInfoView.setupPoints(all: unwrapped)
        }
        title = "Мій профіль"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        seetupUserInfo()
        if let unwrappeedImageUrl = UserImageHelper.shared.profileImageUrl {
            userInfoView.userImageView.downloadImage(url: unwrappeedImageUrl)
        }
    }
    
    private func setupUI() {
        logoutButton.backgroundColor = AppColors.white
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.red.cgColor
        logoutButton.layer.cornerRadius = 10
        logoutButton.setTitleColor(UIColor.red, for: .normal)
        logoutButton.setTitle("Вийти", for: .normal)
    }
    
    private func setupBandView() {
        if bandModel == nil {
            bandPlaceholderView.isHidden = true
        } else {
            bandPlaceholderView.isHidden = false
            bandTitleLabel.text = "Гурток: " + (bandModel?.title ?? "NoName")
            
            var symphatizer = 0, firstChallenge = 0, secondChallenge = 0
            bandModel?.scouts?.forEach({ (scout) in
                switch scout.rang {
                case "sympathizer":
                    symphatizer += 1
                case "first_challenge":
                    firstChallenge += 1
                case "second_challenge":
                    secondChallenge += 1
                default:
                    break
                }
            })
            
            symphatizerLabel.text = "\(symphatizer)\nПрихильників"
            firstChallengeLabel.text = "\(firstChallenge)\nУчасників"
            secondChallengeLabel.text = "\(secondChallenge)\nРозвідувачів"
        }
    }
    
    private func seetupUserInfo() {
        if let unwrappedUser = Scout.currentUser {
            let name = (unwrappedUser.firstName ?? "") + " " + (unwrappedUser.lastName ?? "")
            userInfoView.setInitials(name: name)
            userInfoView.setRang(string: unwrappedUser.rang ?? "")
            userInfoView.nameLabel.text = name
            userInfoView.delegate = self
        }
    }
    
    private func setupSettingButton() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let settingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        settingButton.setImage(UIImage(named: "settings"), for: .normal)
        settingButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        navigationItem.setHidesBackButton(true, animated: false)
        settingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -11)
        let settings = UIBarButtonItem(customView: settingButton)
        
        navigationItem.rightBarButtonItem = settings
    }
    
    @objc private func showSettings() {
        let storyboard = UIStoryboard(name: "UserDescription", bundle: nil)
        let userDescription = storyboard.instantiateViewController(withIdentifier: "UserDescriptionController") as? UserDescriptionController
        userDescription?.type = .userDetails
        userDescription?.user = Scout.currentUser
        navigationController?.pushViewController(userDescription!, animated: true)
    }
    
    @IBAction func logout(_ sender: Any) {
        try? Auth.auth().signOut()
        loadStartController()
    }
    
    private func loadStartController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "StartViewNavigationController")
            UIApplication.shared.delegate?.window??.rootViewController =  controller
        }
    }
}

extension ProfileController: UserInfoViewDelegate {
    func showAddImageController() {
        let storyboard = UIStoryboard(name: "UserDescription", bundle: nil)
        let addPhotoController = storyboard.instantiateViewController(withIdentifier: "AddPhotoController")
        navigationController?.pushViewController(addPhotoController, animated: true)
    }
}
