//
//  ProfileVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 07/12/20.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtFld.isUserInteractionEnabled = false
        addressTxtFld.isUserInteractionEnabled = false
        bioTxtView.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMenu(_ sender: Any) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    
    @IBAction func gotoEditVC(_ sender: Any) {
        let vc = EditProfileVC.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
