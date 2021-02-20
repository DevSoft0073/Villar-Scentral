//
//  ShowAllVideosVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 10/12/20.
//

import UIKit
import LGSideMenuController
import SDWebImage


class ShowAllVideosVC: UIViewController {

    @IBOutlet weak var showAllVideosTBView: UITableView!
    var videoDataArray = [VideoData]()
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

//
//        showAllVideosTBView.reloadData()
        showAllVideosTBView.separatorStyle = .none
//        page = 1
//        getAllVideos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            page = 1
            getAllVideos()
        }
    
    func getAllVideos()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            PKWrapperClass.svprogressHudShow(title: kAppName, view: self)
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.allVideos
            print(url)
            let parms : [String:Any] = ["user_id":id,"pageno":page,"per_page":"100"]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                PKWrapperClass.svprogressHudDismiss(view: self)
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    for obj in response["video_details"] as? [[String:Any]] ?? [[:]]{
                        print(obj)
                        self.videoDataArray.append(VideoData(profileImage: obj["image"] as? String ?? "", videoTitle: obj["title"] as? String ?? "", videoDetails: obj["description"] as? String ?? "", videoThumbnail: obj["pro"] as? String ?? "", videoId: obj["id"] as? String ?? ""))
                    }
                    self.showAllVideosTBView.reloadData()
                }else{
                    PKWrapperClass.svprogressHudDismiss(view: self)
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
    
    
    @IBAction func showMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()

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
        if ((showAllVideosTBView.contentOffset.y + showAllVideosTBView.frame.size.height) >= showAllVideosTBView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.limit * self.pageNo
                getAllVideos()
            }
        }
    }
    
}

class ShowAllVideosTBViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var videoThumbnailImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

struct VideoData {
    var profileImage : String
    var videoTitle: String
    var videoDetails: String
    var videoThumbnail : String
    var videoId : String
    
    init(profileImage : String , videoTitle: String , videoDetails: String , videoThumbnail : String , videoId : String) {
        
        self.profileImage = profileImage
        self.videoTitle = videoTitle
        self.videoDetails = videoDetails
        self.videoThumbnail = videoThumbnail
        self.videoId = videoId
    }
    
}

extension ShowAllVideosVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowAllVideosTBViewCell", for: indexPath) as! ShowAllVideosTBViewCell
        cell.profileImage.setRounded()
        cell.profileImage.sd_setImage(with: URL(string:videoDataArray[indexPath.row].profileImage), placeholderImage: UIImage(named: "img"))
        cell.videoThumbnailImage.sd_setImage(with: URL(string:videoDataArray[indexPath.row].videoThumbnail), placeholderImage: UIImage(named: "pro"))
        cell.titleLbl.text = videoDataArray[indexPath.row].videoTitle
        cell.descriptionLbl.text = videoDataArray[indexPath.row].videoDetails

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        if page <= lastPage{
//            let bottamEdge = Float(self.showAllVideosTBView.contentOffset.y + self.showAllVideosTBView.frame.size.height)
//            if bottamEdge >= Float(self.showAllVideosTBView.contentSize.height) && videoDataArray.count > 0 {
//                page = page + 1
//                getAllVideos()
////            }
//        }
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = VideoPlayVC.instantiate(fromAppStoryboard: .SideMenu)
        vc.videoId = videoDataArray[0].videoId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
