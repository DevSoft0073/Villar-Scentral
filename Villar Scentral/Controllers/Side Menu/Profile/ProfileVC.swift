//
//  ProfileVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 07/12/20.
//

import UIKit
import SDWebImage
import LGSideMenuController


class ProfileVC: UIViewController {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtFld.isUserInteractionEnabled = false
        addressTxtFld.isUserInteractionEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()

    }
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()

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
    
    
    func getData() {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            PKWrapperClass.svprogressHudShow(title: kAppName, view: self)
            let signInUrl = Constant.shared.baseUrl + Constant.shared.profile
            print(signInUrl)
            let parms : [String:Any] = ["user_id" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                PKWrapperClass.svprogressHudDismiss(view: self)
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["user_details"] as? [String:Any]{
                        self.emailTxtFld.text = allData["email"] as? String ?? ""
                        self.addressTxtFld.text = allData["address"] as? String ?? ""
                        self.bioTxtView.text = allData["biography"] as? String ?? ""
                        self.nameLbl.text = allData["name"] as? String ?? ""
                        self.profileImage.sd_setImage(with: URL(string:allData["profile_image"] as? String ?? ""), placeholderImage: UIImage(named: "img"))
                        self.flagImage.sd_setImage(with: URL(string:allData["country_image"] as? String ?? ""), placeholderImage: UIImage(named: "img"))

                        let url = URL(string:allData["profile_image"] as? String ?? "")
                        if url != nil{
                            if let data = try? Data(contentsOf: url!)
                            {
                                if let image: UIImage = (UIImage(data: data)){
                                    self.profileImage.image = image
                                    self.profileImage.contentMode = .scaleToFill
                                    PKWrapperClass.svprogressHudDismiss(view: self)
                                }
                            }
                        }
                        else{
                            self.profileImage.image = UIImage(named: "img")
                        }
                        let urls = URL(string:allData["country_image"] as? String ?? "")
                        if urls != nil{
                            if let data = try? Data(contentsOf: urls!)
                            {
                                if let image: UIImage = (UIImage(data: data)){
                                    self.flagImage.image = image
                                    self.flagImage.contentMode = .scaleToFill
                                    PKWrapperClass.svprogressHudDismiss(view: self)
                                }
                            }
                        }
                        else{
                            self.flagImage.image = UIImage(named: "flag")
                        }
                    }
                }else{
                    PKWrapperClass.svprogressHudDismiss(view: self)
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
            }) { (error) in
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
    }
    
}
