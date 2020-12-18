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
    var nameArray = ["Home","Other Products","Order History","Video tutorials","Store Locator","Settings"]
    var imgArray = ["home","product-icon","order-history","video-tutorial","store-locator","setting"]
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTBView.separatorStyle = .none
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer() {
        
        self.updateLocation()
        
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
            let vc = OtherProductsVC.instantiate(fromAppStoryboard: .SideMenu)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            
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
            let vc = StoreLocatorVC.instantiate(fromAppStoryboard: .SideMenu)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            
        }
                        
        else if(indexPath.row == 5) {
            let vc = ProfileVC.instantiate(fromAppStoryboard: .SideMenu)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
