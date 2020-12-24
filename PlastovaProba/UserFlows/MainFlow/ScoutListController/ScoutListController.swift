//
//  ActionPlaceholderController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import SwipeCellKit

class ScoutListController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
  
    @IBOutlet weak var tableView: UITableView!
    
    private var registrationDataSourceModel = RegistrationDataSourceModel()
    
    var coordinator: HomeCoordinator?
    var dataSource: BandModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        tableView.allowsSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.prepareData()
        }
        prepareData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ScoutTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoutTableViewCell")
        tableView.register(UINib.init(nibName: "AddNewScoutTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewScoutTableViewCell")
    }
    
    func prepareData() {
        registrationDataSourceModel.getScouts { [weak self] (scouts, error) in
            if let unwrappedScouts = scouts {
                self?.dataSource = unwrappedScouts
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func deleteScout(at index: Int) {
        let email = dataSource?.scouts?[index].email ?? ""
        registrationDataSourceModel.deleteScout(email: email) { (success) in
            if success {
                self.prepareData()
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Помилка", message: "Помилка", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Окай", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dataSource?.scouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewScoutTableViewCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoutTableViewCell", for: indexPath) as? ScoutTableViewCell
        cell?.delegate = self
        cell?.setupInfo(scout: dataSource?.scouts?[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MainFlow", bundle: nil)
        if indexPath.row == 0 && indexPath.section == 0 {
            let scoutListController = storyboard.instantiateViewController(withIdentifier: "AddNewScoutController") as? AddNewScoutController
            coordinator?.push(viewController: scoutListController, isNavigationBarHidden: false)
        } else {
            if let applicationController = storyboard.instantiateViewController(withIdentifier: "ApplicationController") as? ApplicationController {
                applicationController.type = .scout_master
                applicationController.scout = dataSource?.scouts?[indexPath.row]
                coordinator?.push(viewController: applicationController, isNavigationBarHidden: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Видалити") { action, indexPath in
            self.deleteScout(at: indexPath.row)
        }
        
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
}
