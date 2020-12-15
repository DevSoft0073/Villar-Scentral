//
//  SignUpVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 05/12/20.
//

import UIKit

class SignUpVC: UIViewController  , UITextFieldDelegate{

    @IBOutlet weak var checkUncheckButton: UIButton!
    @IBOutlet weak var confirmPasswordLbl: UILabel!
    @IBOutlet weak var confirmPasswordTxtFld: UITextField!
    @IBOutlet weak var passwordBootamLbl: UILabel!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var usernameBottamLbl: UILabel!
    @IBOutlet weak var usernameTxtFld: UITextField!
    var messgae = String()
    var unchecked = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameTxtFld {
            usernameBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            passwordBootamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            confirmPasswordLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        } else if textField == passwordTxtFld{
            usernameBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            passwordBootamLbl.backgroundColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            confirmPasswordLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }else if textField == confirmPasswordTxtFld{
            usernameBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            passwordBootamLbl.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            confirmPasswordLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
    }
    @IBAction func checkUncheckButton(_ sender: UIButton) {
        if (unchecked == false)
        {
            checkUncheckButton.setBackgroundImage(UIImage(named: "check-icon"), for: UIControl.State.normal)
            unchecked = true
        }
        else
        {
            checkUncheckButton.setBackgroundImage(UIImage(named: "check-icon-1"), for: UIControl.State.normal)
            unchecked = false
        }
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        if (usernameTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter name")
        }
//        else if isValidEmail(testStr: (emailtxtFld.text)!) == false{
//
//            ValidateData(strMessage: "Enter valid email")
//        }
        else if (passwordTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter password")
        }else if (passwordTxtFld!.text!.count) < 4 || (passwordTxtFld!.text!.count) > 15{
            
            ValidateData(strMessage: "Please enter minimum 4 digit password")
            UserDefaults.standard.string(forKey: "password")
            
        }else if (confirmPasswordTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter password")
        }else if (confirmPasswordTxtFld!.text!.count) < 4 || (confirmPasswordTxtFld!.text!.count) > 15{
            
            ValidateData(strMessage: "Please enter minimum 4 digit password")
            UserDefaults.standard.string(forKey: "password")
            
        }else if (passwordTxtFld.text != confirmPasswordTxtFld.text){
            
            ValidateData(strMessage: "Password does not match")
        }else if unchecked == false{
            
            ValidateData(strMessage: "Please agree terms and conditions")
        }
        else{
            signUp()
        }

      
    }
    
    @IBAction func gotoSignInVC(_ sender: Any) {
    
        self.navigationController?.popViewController(animated: true)
        
    }
        
    func signUp()  {
                
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let url = Constant.shared.baseUrl + Constant.shared.SignUP
            let deviceToken = UserDefaults.standard.value(forKey: DefaultKeys.deviceToken) as? String ?? "529173FB75AC135EE09EE7186B98C89DBC72C2CC0EF25C242EA7DA31BD292EFC"
            let params = ["name":usernameTxtFld.text ?? "","password":passwordTxtFld.text ?? "", "confirm_password":confirmPasswordTxtFld.text ?? "","device_token":deviceToken,"device_type":Constant.shared.device_token] as [String : Any]
            AFWrapperClass.requestPOSTURL(url, params: params, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.messgae = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    UserDefaults.standard.set(true, forKey: "tokenFString")
                    let allData = response as? [String:Any] ?? [:]
                    print(allData)
                    if let data = allData["user_detail"] as? [String:Any]  {
                        UserDefaults.standard.set(data["id"], forKey: "id")
                        print(data)
                    }
                    let story = UIStoryboard(name: "SideMenu", bundle: nil)
                    let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
                    self.navigationController?.pushViewController(rootViewController, animated: true)
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.messgae, view: self)
                }
            }) { (error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
        
    }

    
    
}
