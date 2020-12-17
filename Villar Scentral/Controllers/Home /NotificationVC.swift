//
//  NotificationVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 05/12/20.
//

import UIKit

class NotificationVC: UIViewController {
    
    var notificationArray = [NotificationData]()
    var message = String()
    var page = Int()
    var lastPage = Bool()
    @IBOutlet weak var notificationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationArray.append(NotificationData(image: "img", name: "a", details: "Thank you for your order. We will deliver your order as soon as possible."))
        notificationArray.append(NotificationData(image: "img", name: "a", details: "Thank you for your order. We will deliver your order as soon as possible."))
        notificationArray.append(NotificationData(image: "img", name: "a", details: "Thank you for your order. We will deliver your order as soon as possible."))
        notificationArray.append(NotificationData(image: "img", name: "a", details: "Thank you for your order. We will deliver your order as soon as possible."))
        notificationArray.append(NotificationData(image: "img", name: "a", details: "Thank you for your order. We will deliver your order as soon as possible."))
        notificationArray.append(NotificationData(image: "img", name: "a", details: "Thank you for your order. We will deliver your order as soon as possible."))
        notificationArray.append(NotificationData(image: "img", name: "a", details: "Thank you for your order. We will deliver your order as soon as possible."))
        
        notificationTableView.reloadData()
        notificationTableView.separatorStyle = .none
        
        
        // Do any additional setup after loading the view.
        
        page = 1
        notificationData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        page = 1
        notificationData()
    }
    
    func notificationData()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.notification
            print(url)
            let parms : [String:Any] = ["user_id":id,"pageno":page,"per_page":"100"]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
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
    
}

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension NotificationVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.usernameLbl.text = notificationArray[indexPath.row].name
        cell.detailsLbl.text = notificationArray[indexPath.row].details
        cell.userImage.image = UIImage(named: notificationArray[indexPath.row].image)
        cell.userImage.setRounded()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrderAcceptedVC.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

struct NotificationData {
    var image : String
    var name : String
    var details : String
    
    init(image : String,name : String,details : String) {
        self.image = image
        self.name = name
        self.details = details
    }
}
