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
    var page = Int()
    var lastPage = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
//        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
//        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
//        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
//        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
//        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
//
//        showAllVideosTBView.reloadData()
        showAllVideosTBView.separatorStyle = .none
        page = 1
        getAllVideos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            page = 1
            getAllVideos()
        }
    
    func getAllVideos()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.allVideos
            print(url)
            let parms : [String:Any] = ["user_id":id,"pageno":page,"per_page":"10"]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                self.videoDataArray.removeAll()
                if status == 1{
                    for obj in response["video_details"] as? [[String:Any]] ?? [[:]]{
                        print(obj)
                        self.videoDataArray.append(VideoData(profileImage: obj["image"] as? String ?? "", videoTitle: obj["title"] as? String ?? "", videoDetails: obj["description"] as? String ?? "", videoThumbnail: obj["pro"] as? String ?? ""))
                    }
                    self.showAllVideosTBView.reloadData()
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
    
    @IBAction func showMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()

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
    
    init(profileImage : String , videoTitle: String , videoDetails: String , videoThumbnail : String) {
        
        self.profileImage = profileImage
        self.videoTitle = videoTitle
        self.videoDetails = videoDetails
        self.videoThumbnail = videoThumbnail
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
//        cell.videoThumbnailImage.image = UIImage(named: videoDataArray[indexPath.row].videoThumbnail)
        cell.titleLbl.text = videoDataArray[indexPath.row].videoTitle
        cell.descriptionLbl.text = videoDataArray[indexPath.row].videoDetails

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}
