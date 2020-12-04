//
//  ActionPlaceholderController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class ScoutListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var coordinator: HomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        tableView.allowsSelection = true
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ScoutTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoutTableViewCell")
        tableView.register(UINib.init(nibName: "AddNewScoutTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewScoutTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewScoutTableViewCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoutTableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MainFlow", bundle: nil)
        let scoutListController = storyboard.instantiateViewController(withIdentifier: "AddNewScoutController") as? AddNewScoutController
        
        
        coordinator?.push(viewController: scoutListController, isNavigationBarHidden: false)
    }
}
