//
//  SignUpVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 05/12/20.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var confirmPasswordLbl: UILabel!
    @IBOutlet weak var confirmPasswordTxtFld: UITextField!
    @IBOutlet weak var passwordBootamLbl: UILabel!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var usernameBottamLbl: UILabel!
    @IBOutlet weak var usernameTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        let vc = SideMenuVC.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func gotoSignInVC(_ sender: Any) {
        
        let story = UIStoryboard(name: "SideMenu", bundle: nil)
        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
        self.navigationController?.pushViewController(rootViewController, animated: true)
       
                
//        let vc = ProfileVC.instantiate(fromAppStoryboard: .SideMenu)
//        self.navigationController?.popViewController(animated: true)
    }
}
