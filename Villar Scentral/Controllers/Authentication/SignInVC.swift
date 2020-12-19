//
//  SignInVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 05/12/20.
//

import UIKit

class SignInVC: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var passworsBottamLbl: UILabel!
    @IBOutlet weak var usernameBottamLbl: UILabel!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var usernameTxTFld: UITextField!
    var messgae = String()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameTxTFld {
            usernameBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            passworsBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        } else if textField == passwordTxtFld{
            usernameBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            passworsBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
    }
    
    
    
    @IBAction func signInButtonAction(_ sender: Any) {
       
        
        if (usernameTxTFld.text?.isEmpty)!{

            ValidateData(strMessage: " Please enter username")
        }        else if (passwordTxtFld.text?.isEmpty)!{

            ValidateData(strMessage: " Please enter password")
        }else{
            self.signIn()
        }
        
    }
        
    func signIn()  {
                
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let url = Constant.shared.baseUrl + Constant.shared.SignIN
            let deviceToken = UserDefaults.standard.value(forKey: DefaultKeys.deviceToken) as? String ?? "529173FB75AC135EE09EE7186B98C89DBC72C2CC0EF25C242EA7DA31BD292EFC"
            let params = ["name":usernameTxTFld.text ?? "","password":passwordTxtFld.text ?? "","device_token":deviceToken,"device_type":Constant.shared.device_token] as [String : Any]
            AFWrapperClass.requestPOSTURL(url, params: params, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.messgae = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    UserDefaults.standard.set(true, forKey: "tokenFString")
                    let allData = response as? [String:Any] ?? [:]
                    print(allData)
                    if let data = allData["data"] as? [String:Any]  {
                        UserDefaults.standard.set(data["userID"], forKey: "id")
                        UserDefaults.standard.set(data["authToken"], forKey: "authToken")
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
    

    @IBAction func gotoForgotPasswordVC(_ sender: Any) {
        let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func gotoSignUpVC(_ sender: Any) {
        let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


struct LocationData {
    var long : Double
    var lat : Double
    
    init(long : Double,lat : Double ) {
        self.lat = lat
        self.long = long
    }
}
