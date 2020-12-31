//
//  VideoPlayVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 18/12/20.
//

import UIKit
import VersaPlayer
import AVFoundation

class VideoPlayVC: UIViewController {

    @IBOutlet var controls: VersaPlayerControls!
    @IBOutlet weak var playerView: VersaPlayerView!
    var message = String()
    var videoId = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        videoDetails()

    }
    
    func videoDetails()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.videoDetails
            print(url)
            let parms : [String:Any] = ["user_id":id,"video_id":videoId as? String ?? "0"]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    let videoDetails = response["video_detail"] as? [String:Any] ?? [:]
                    self.playerView.layer.backgroundColor = UIColor.black.cgColor
                    self.playerView.use(controls: self.controls)
                    self.playerView.controls?.behaviour.shouldShowControls
                           
                           if let url = URL.init(string: videoDetails["video"] as? String ?? "") {
                               let item = VersaPlayerItem(url: url)
                            self.playerView.set(item: item)
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
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


