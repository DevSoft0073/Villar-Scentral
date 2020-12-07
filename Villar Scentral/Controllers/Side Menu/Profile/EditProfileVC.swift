//
//  EditProfileVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 07/12/20.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var bioTXtView: UITextView!
    @IBOutlet weak var addressBottamLbl: UILabel!
    @IBOutlet weak var emailBottamLbl: UILabel!
    @IBOutlet weak var addressLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addProfileImageButton(_ sender: Any) {
    }
}
