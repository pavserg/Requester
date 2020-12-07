//
//  CollectionTableViewCell.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 07.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib.init(nibName: "GategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GategoryCollectionViewCell")
    }
}
