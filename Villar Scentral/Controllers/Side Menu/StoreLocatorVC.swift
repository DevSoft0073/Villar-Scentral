//
//  StoreLocatorVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 08/12/20.
//

import UIKit
import LGSideMenuController


class StoreLocatorVC: UIViewController {

    var storeLocatorArray = [StoreLocatorData]()
    @IBOutlet weak var storeLocatorTBView: UITableView!
    var message = String()
    var page = Int()
    var lastPage = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()

        storeLocatorTBView.separatorStyle = .none
        
//        storeLocatorArray.append(StoreLocatorData(name: "Essences For Life", details: "details: Villar Scentral", distance: "20 Miles", openClose: "Closed Now", image: "img"))
//        storeLocatorArray.append(StoreLocatorData(name: "Essences For Life", details: "details: Villar Scentral", distance: "20 Miles", openClose: "Closed Now", image: "img"))
//        storeLocatorArray.append(StoreLocatorData(name: "Essences For Life", details: "details: Villar Scentral", distance: "20 Miles", openClose: "Closed Now", image: "img"))
//        storeLocatorArray.append(StoreLocatorData(name: "Essences For Life", details: "details: Villar Scentral", distance: "20 Miles", openClose: "Closed Now", image: "img"))
//
//        page = 1
//        storeLocator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        page = 1
        storeLocator()
    }
    
    func storeLocator()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.nearByStore
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
                    self.storeLocatorTBView.reloadData()
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



    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()

    }
}

class StoreLocatorTBViewCll: UITableViewCell {
    
    @IBOutlet weak var openCloseLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var detailslbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension StoreLocatorVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return storeLocatorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreLocatorTBViewCll", for: indexPath) as! StoreLocatorTBViewCll
        cell.showImage.image = UIImage(named: storeLocatorArray[indexPath.item].image)
        cell.nameLbl.text = storeLocatorArray[indexPath.item].name
        cell.detailslbl.text = storeLocatorArray[indexPath.item].details
        cell.distanceLbl.text = storeLocatorArray[indexPath.item].distance
        cell.openCloseLbl.text = storeLocatorArray[indexPath.item].openClose
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}

struct StoreLocatorData {
    var name : String
    var details : String
    var distance : String
    var openClose : String
    var image : String
    
    init(name : String , details : String , distance : String , openClose : String , image : String) {
        self.name = name
        self.details = details
        self.distance = distance
        self.openClose = openClose
        self.image = image
    }
}
