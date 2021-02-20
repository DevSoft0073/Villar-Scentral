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
    
    
    
    //For Pagination
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=20
    var offset:Int=0 //pageNo*limit
    var didEndReached:Bool=false

    
    
    
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
        page = 1
        notificationData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        page = 1
        notificationData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }



    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        print("scrollViewDidEndDragging")
        if ((notificationTableView.contentOffset.y + notificationTableView.frame.size.height) >= notificationTableView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.limit * self.pageNo
                notificationData()
            }
        }
    }
    
    func notificationData()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            PKWrapperClass.svprogressHudShow(title: kAppName, view: self)
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.notification
            print(url)
            let parms : [String:Any] = ["user_id":id,"pageno":page,"per_page":"100"]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                PKWrapperClass.svprogressHudDismiss(view: self)
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
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
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        if page <= lastPage{
//            let bottamEdge = Float(self.notificationTableView.contentOffset.y + self.notificationTableView.frame.size.height)
//            if bottamEdge >= Float(self.notificationTableView.contentSize.height) && notificationArray.count > 0 {
//                page = page + 1
//                notificationData()
////            }
//        }
//    }
    
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
