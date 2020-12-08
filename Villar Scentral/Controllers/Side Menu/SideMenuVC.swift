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
    var nameArray = ["Home","Other Products","Order History","Video tutorials","Store Locator","Settings"]
    var imgArray = ["home","product-icon","order-history","video-tutorial","store-locator","setting"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
             
        }
            
        else if(indexPath.row == 1) {
            
        }
            
        else if(indexPath.row == 2) {
             
        }
            
        else if(indexPath.row == 3) {
            
        }
            
        else if(indexPath.row == 4) {
            
        }
                        
        else if(indexPath.row == 5) {
            
         
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
