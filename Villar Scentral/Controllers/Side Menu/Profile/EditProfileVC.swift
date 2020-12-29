//
//  EditProfileVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 07/12/20.
//

import UIKit
import SDWebImage

class EditProfileVC: UIViewController , UITextFieldDelegate ,UITextViewDelegate {

    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var bioTXtView: UITextView!
    @IBOutlet weak var addressBottamLbl: UILabel!
    @IBOutlet weak var emailBottamLbl: UILabel!
    @IBOutlet weak var addressLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    var message = String()
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        getData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailLbl {
            emailBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            addressBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            
        } else if textField == addressLbl{
            emailBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            addressBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        editProfile()
        
//        let story = UIStoryboard(name: "SideMenu", bundle: nil)
//        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
//        self.navigationController?.pushViewController(rootViewController, animated: true)
    }
    
    
    @IBAction func addProfileImageButton(_ sender: UIButton) {
        
        self.imagePicker.present(from: sender)        
        
    }
    
    func getData() {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.profile
            print(signInUrl)
            let parms : [String:Any] = ["user_id" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["user_details"] as? [String:Any]{
                        self.emailLbl.text = allData["name"] as? String ?? ""
                        self.addressLbl.text = allData["address"] as? String ?? ""
                        self.bioTXtView.text = allData["biography"] as? String ?? ""
                        self.nameTxtFld.text = allData["name"] as? String ?? ""
                        self.profileImage.sd_setImage(with: URL(string:allData["profile_image"] as? String ?? ""), placeholderImage: UIImage(named: "img"))
                        let url = URL(string:allData["image"] as? String ?? "")
                        if url != nil{
                            if let data = try? Data(contentsOf: url!)
                            {
                                if let image: UIImage = (UIImage(data: data)){
                                    self.profileImage.image = image
                                    self.profileImage.contentMode = .scaleToFill
                                    IJProgressView.shared.hideProgressView()
                                }
                            }
                        }
                        else{
                            self.profileImage.image = UIImage(named: "img")
                        }
                    }
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
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

    
    func editProfile() {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let url = Constant.shared.baseUrl + Constant.shared.EditProfile
            print(url)
            var base64String = String()
            base64String = UserDefaults.standard.value(forKey: "imag") as? String ?? ""
                        
            let parms : [String:Any] = ["user_id": id,"email" : emailLbl.text ?? "","address" : addressLbl.text ?? "" ,"image" : base64String,"bio" : bioTXtView.text ?? "" ,"latitude" : "" , "longitude" : "" , "name":nameTxtFld.text ?? ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["userDetails"] as? [String:Any] {
                        IJProgressView.shared.hideProgressView()
                    }
                    let story = UIStoryboard(name: "SideMenu", bundle: nil)
                    let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
                    self.navigationController?.pushViewController(rootViewController, animated: true)                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
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

extension EditProfileVC: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.profileImage.image = image
    }
}
