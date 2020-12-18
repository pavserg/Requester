//
//  ApplicationController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 07.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class ApplicationController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var challengeDataSource = ChallengesDataSource()
    private var challengeModel: Challenge?
    private var collectionViewChallengeModel: Challenge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXibs()
        setupInfoHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //getFirstChallenge()
        getSecondChallenge()
        //getGeneralChallenge()
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
        if let topic = challengeModel?.sections?[indexPath.section].topics?[indexPath.row] {
            cell?.fillWith(info: topic)
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
