//
//  StoreLocatorVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 08/12/20.
//

import UIKit
import LGSideMenuController
import SDWebImage

class StoreLocatorVC: UIViewController {

    var storeLocatorArray = [StoreLocatorData]()
    @IBOutlet weak var storeLocatorTBView: UITableView!
    var message = String()
    var page = 1
    var lastPage = 1
    
    
    //For Pagination
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=20
    var offset:Int=0 //pageNo*limit
    var didEndReached:Bool=false

    
    
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
        if ((storeLocatorTBView.contentOffset.y + storeLocatorTBView.frame.size.height) >= storeLocatorTBView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.limit * self.pageNo
                storeLocator()
            }
        }
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
                self.storeLocatorArray.removeAll()
                if status == 1{
                    for obj in response["store_detail"] as? [[String:Any]] ?? [[:]]{
                        self.storeLocatorArray.append(StoreLocatorData(name: obj["name"] as? String ?? "", details: obj["address"] as? String ?? "", distance: obj["distance"] as? String ?? "", openClose: obj["status"] as? String ?? "", image: obj["photo"] as? String ?? "", id: obj["id"] as? String ?? ""))
                    }
                    self.storeLocatorTBView.reloadData()
                }else{
                    IJProgressView.shared.hideProgressView()
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
        cell.showImage.sd_setImage(with: URL(string:storeLocatorArray[indexPath.item].image), placeholderImage: UIImage(named: "img"))
        cell.showImage.setRounded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        if page <= lastPage{
//            let bottamEdge = Float(self.storeLocatorTBView.contentOffset.y + self.storeLocatorTBView.frame.size.height)
//            if bottamEdge >= Float(self.storeLocatorTBView.contentSize.height) && storeLocatorArray.count > 0 {
//                page = page + 1
//                storeLocator()
////            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let vc = StoreDetailVC.instantiate(fromAppStoryboard: .SideMenu)
        vc.name = storeLocatorArray[indexPath.row].name
        vc.image = storeLocatorArray[indexPath.row].image
        vc.storeId = storeLocatorArray[indexPath.row].id
        vc.address = storeLocatorArray[indexPath.row].details
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

struct StoreLocatorData {
    var name : String
    var details : String
    var distance : String
    var openClose : String
    var image : String
    var id : String
    
    init(name : String , details : String , distance : String , openClose : String , image : String ,id : String) {
        self.name = name
        self.details = details
        self.distance = distance
        self.openClose = openClose
        self.image = image
        self.id = id
    }
}
