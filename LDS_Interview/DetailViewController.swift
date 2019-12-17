//
//  DetailViewController.swift
//  LDS_Interview
//
//  Created by Jeremy Barger on 12/17/19.
//  Copyright © 2019 Jeremy Barger. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    weak var person: Person?
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var birthDateLabel: UILabel!
    
    @IBOutlet weak var forceLabel: UILabel!
    
    @IBOutlet weak var affiliationLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameLabel.text = person?.firstName
        lastNameLabel.text = person?.lastName
        birthDateLabel.text = person?.birthDate
        forceLabel.text = person?.forceSensitive.description
        affiliationLabel.text = person?.affiliation
        idLabel.text = person?.id.description
        
    }
    
    
    
}
