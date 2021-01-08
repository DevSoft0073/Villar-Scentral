//
//  SideMenuVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 08/12/20.
//

import UIKit
import LGSideMenuController

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var settingTBView: UITableView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var timer: Timer?
    var nameArray = ["Home","Other Products","Order History","Video Tutorials","Invite","Store Locator","Settings","Logout"]
    var imgArray = ["home","product-icon","order-history","video-tutorial","invitation","store-locator","setting","logout"]
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTBView.separatorStyle = .none
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        getData()
    }
    
    @objc func fireTimer() {
        
        self.updateLocation()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
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
                        self.nameLbl.text = allData["name"] as? String ?? ""
                        self.cityLbl.text = allData["email"] as? String ?? ""
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
    
    
    func updateLocation() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let authToken = UserDefaults.standard.value(forKey: "authToken") as? String ?? ""
            let signInUrl = Constant.shared.baseUrl + Constant.shared.currentLocation
            print(signInUrl)
            let parms : [String:Any] = ["latitude" : Singleton.sharedInstance.lat,"longitude" : Singleton.sharedInstance.long,"authToken" :  authToken ,"user_id" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { [self] (response) in
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                }else{
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
    
    func logout() {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let signInUrl = Constant.shared.baseUrl + Constant.shared.currentLocation
            print(signInUrl)
            let parms : [String:Any] = ["user_id":id]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { [self] (response) in
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    //                    UserDefaults.standard.set(false, forKey: "tokenFString")
                    UserDefaults.standard.set(0, forKey: "tokenFString")
                    
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.getLoggedUser()
                    //                    UserDefaults.standard.set(false, forKey: "tokenFString")
                    //                    Switcher.updateRootVC()
                    
                }else{
                    
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



class SettingTBViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var iconImages: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension SideMenuVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTBViewCell", for: indexPath) as! SettingTBViewCell
        cell.nameLbl.text = nameArray[indexPath.row]
        cell.iconImages.image = UIImage(named: imgArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sideMenuController?.hideLeftViewAnimated()
        
        if(indexPath.row == 0) {
            let vc = HomeVC.instantiate(fromAppStoryboard: .SideMenu)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
        }
            
        else if(indexPath.row == 1) {
            //            let vc = OtherProductsVC.instantiate(fromAppStoryboard: .SideMenu)
            //            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            guard let url = URL(string: "https://stackoverflow.com") else { return }
            UIApplication.shared.open(url)
            
        }
            
        else if(indexPath.row == 2) {
            let vc = OrderHistoryVC.instantiate(fromAppStoryboard: .SideMenu)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            
        }
            
        else if(indexPath.row == 3) {
            let vc = ShowAllVideosVC.instantiate(fromAppStoryboard: .SideMenu)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
        }
            
        else if(indexPath.row == 4) {
            
            if let name = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8"), !name.absoluteString.isEmpty {
                let objectsToShare = [name]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.present(activityVC, animated: true, completion: nil)
            }else  {
                // show alert for not available
                alert(Constant.shared.appTitle, message: "App not on app store right now ", view: self)
            }
            
        }
            
        else if(indexPath.row == 5) {
            let vc = StoreLocatorVC.instantiate(fromAppStoryboard: .SideMenu)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            
        }
            
        else if(indexPath.row == 6) {
            let vc = ProfileVC.instantiate(fromAppStoryboard: .SideMenu)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
        }
            
        else if (indexPath.row == 7) {
            let dialogMessage = UIAlertController(title: Constant.shared.appTitle, message: "Are you sure you want to Logout?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button click...")
                UserDefaults.standard.set(false, forKey: "tokenFString")
                self.logout()
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button click...")
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
