//
//  ShowAllVideosVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 10/12/20.
//

import UIKit
import LGSideMenuController


class ShowAllVideosVC: UIViewController {

    @IBOutlet weak var showAllVideosTBView: UITableView!
    var videoDataArray = [VideoData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
        videoDataArray.append(VideoData(profileImage: "img", videoTitle: "First Video", videoDetails: "FIrst Video", videoThumbnail: "pro"))
        
        showAllVideosTBView.reloadData()
        showAllVideosTBView.separatorStyle = .none
        
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
        cell.profileImage.image = UIImage(named: videoDataArray[indexPath.row].profileImage)
        cell.videoThumbnailImage.image = UIImage(named: videoDataArray[indexPath.row].videoThumbnail)
        cell.titleLbl.text = videoDataArray[indexPath.row].videoTitle
        cell.descriptionLbl.text = videoDataArray[indexPath.row].videoDetails

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}
