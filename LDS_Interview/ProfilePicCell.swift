//
//  ProfilePicCell.swift
//  LDS_Interview
//
//  Created by Jeremy Barger on 12/17/19.
//  Copyright © 2019 Jeremy Barger. All rights reserved.
//

import Foundation
import UIKit

class ProfilePicCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    
    func setPersonCellWith(person: Person) {
        DispatchQueue.main.async {
            if let url = person.profilePic {
                self.profileImage.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }
    }
    
}

