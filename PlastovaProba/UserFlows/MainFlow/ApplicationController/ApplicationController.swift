//
//  ApplicationController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 07.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import RLBAlertsPickers
 
enum ApplicationControllerType {
    case scout
    case scout_master
}

class ApplicationController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var challengeDataSource = ChallengesDataSource()
    private var challengeModel: Challenge?
    private var collectionViewChallengeModel: Challenge?
    
    private var activeChallenge: [String: Bool]?
    
    
    var type: ApplicationControllerType = .scout
    var scout: Scout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        setupData()
        registerXibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    func setupData() {
        collectionViewChallengeModel = nil
        if type == .scout_master || navigationController?.viewControllers.count ?? 0 > 1 {
            
            reloadActiveChallenge()
            
            setupInfoHeader()
            //"sympathizer", "first_challenge", "second_challenge"
            if let rang = scout?.rang {
                switch rang {
                case "sympathizer":
                    getGeneralChallenge()
                case "first_challenge":
                    getFirstChallenge()
                case "second_challenge":
                    getSecondChallenge()
                default:
                    break
                }
            }
        }
    }
    
    private func reloadActiveChallenge() {
        if let unwrappedScoutId =  scout?.id {
            challengeDataSource.activeChallengeBy(id: unwrappedScoutId) { (result, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        self.activeChallenge = result
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func registerXibs() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        tableView.register(UINib.init(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        tableView.register(UINib.init(nibName: "ChallengeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ChallengeHeaderView")
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 25
    }
    
    private func setupInfoHeader() {
        let userInfo = UserInfoView(frame: CGRect.init(x: 0, y: 0, width: 360, height: 252))
        userInfo.delegate = self
        if let unwrappedScout = scout {
            userInfo.nameLabel.text = (unwrappedScout.firstName ?? "") + " " + (unwrappedScout.lastName ?? "")
            userInfo.setInitials(name: (unwrappedScout.firstName ?? "") + " " + (unwrappedScout.lastName ?? ""))
            
            userInfo.setRang(string: unwrappedScout.rang)
        }
        tableView.tableHeaderView = userInfo
    }
    
    private func getFirstChallenge() {
        challengeDataSource.getFirstChallenge { [weak self] (firstChallenge, error) in
            self?.challengeModel = firstChallenge
            if let copied = firstChallenge?.copy() as? Challenge {
                self?.collectionViewChallengeModel = copied
            }
            let dummySection =  Section(name: "Dummy", id: "Dummy", topics: [Topic.init(id: "Dummy", question: "Dummy")])
            self?.challengeModel?.sections?.insert(dummySection, at: 0)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func getSecondChallenge() {
        challengeDataSource.getSecondChallenge { [weak self] (secondChallenge, error) in
            self?.challengeModel = secondChallenge
            if let copied = secondChallenge?.copy() as? Challenge {
                self?.collectionViewChallengeModel = copied
            }
            let dummySection = Section(name: "Dummy", id: "Dummy", topics: [Topic.init(id: "Dummy", question: "Dummy")])
            self?.challengeModel?.sections?.insert(dummySection, at: 0)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func getGeneralChallenge() {
        challengeDataSource.getGeneralChallenge { [weak self] (generalChallenge, error) in
            self?.challengeModel = generalChallenge
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (challengeModel?.sections?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeModel?.sections?[section].topics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 && (collectionViewChallengeModel?.sections?.count ?? 0 > 1)  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as? CollectionTableViewCell
            cell?.collectionView.delegate = self
            cell?.collectionView.dataSource = self
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as? QuestionTableViewCell
        if let topic = challengeModel?.sections?[indexPath.section].topics?[indexPath.row], let unwrappeedId = topic.id {
            cell?.fillWith(info: topic, isSelected: activeChallenge?[unwrappeedId] ?? false)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if challengeModel?.sections?.count == 1 {
            return nil
        }
        if section == 0 { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ChallengeHeaderView") as? ChallengeHeaderView
        header?.headerTitleLabel.text = challengeModel?.sections?[section].name ?? ""
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if challengeModel?.sections?.count == 1 {
            return 0.001
        }
        if section == 0 { return 0.001 }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let unwrappedScout = scout, let scoutId = unwrappedScout.id, let rang = unwrappedScout.rang, let pointId = challengeModel?.sections?[indexPath.section].topics?[indexPath.row].id else { return }
        
        challengeDataSource.update(userIdentifier: scoutId, pointIdentifier: pointId.lowercased(), rang: rang) { (error) in
            if error == nil {
                self.reloadActiveChallenge()
            }
        }
    }
}

extension ApplicationController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionViewChallengeModel?.sections?.count == 1 {
            return 0
        }
        return collectionViewChallengeModel?.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GategoryCollectionViewCell", for: indexPath) as? GategoryCollectionViewCell
        if let section = collectionViewChallengeModel?.sections?[indexPath.row] {
            cell?.fillWithInfo(section: section)
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 128, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: indexPath.row + 1), at: .top, animated: true)
    }
}

extension ApplicationController: UserInfoViewDelegate {
    func showRangPicker() {
        showRangPickerView()
    }
    
    private func showRangPickerView() {
        view.endEditing(true)
        let alert = UIAlertController(style: .actionSheet, title: "Вибери ступінь", message: "")
        let frameSizes: [CGFloat] = (150...400).map { CGFloat($0) }
        let pickerViewValues: [[String]] = [["Прихильник/ця",  "Учасник/ця", "Розвідувач/ка"]]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            switch index.row {
            case 0:
                self.changeRang(string: "sympathizer")
            case 1:
                self.changeRang(string: "first_challenge")
            case 2:
                self.changeRang(string: "second_challenge")
            default:
                break
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    func changeRang(string: String) {
        guard let identifier = scout?.id else { return }
        UserDataSourceModel().updateRang(rangString: string, identifier: identifier) { (scout, error) in
            if error == nil && scout != nil {
                self.scout = scout
                DispatchQueue.main.async {
                    self.setupData()
                }
            }
        }
    }
}
