//
//  ViewController.swift
//  MusicPlayer_Swift
//
//  Created by 张健 on 15/3/25.
//  Copyright (c) 2015年 ForLove. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, HttpHandlerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var titleImageView: UIImageView!

    @IBOutlet weak var musicListTableView: UITableView!
    
    @IBOutlet weak var playProgressView: UIProgressView!
    
    @IBOutlet weak var timeLabel: UILabel!
    //所有音乐的详细信息
    var musicData = [NSDictionary]()
    
    //图片缓存
    var pictureCache = [String:UIImage]()
    var handler : HttpHandler = HttpHandler()
    
    var currentChannel : String = "0" {
        willSet {
            handler.request("http://www.douban.com/j/app/radio/channels"+newValue)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        handler.delegate = self
        handler.request("http://douban.fm/j/mine/playlist?channel=0")
    }
    
    func didReceivedData(json: NSDictionary) {
        if json["song"] != nil{
            dispatch_async(dispatch_get_main_queue()
                , { () -> Void in
                    self.musicData = json["song"] as [NSDictionary]
                    self.musicListTableView.reloadData()
            })
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return musicData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MusicCell", forIndexPath: indexPath ) as UITableViewCell
        let rowData = musicData[indexPath.row] as NSDictionary
        cell.textLabel?.text = rowData["title"] as NSString
        cell.detailTextLabel?.text = rowData["artist"] as NSString
//        String(format: "%@ %@", arguments: rowData["album"],rowData["artist"])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowData = musicData[indexPath.row]
        let urlString = rowData["url"] as String
        playAudio(urlString)
        //更换图片
        let pictureURL = rowData["picture"] as String
        if let image = pictureCache[pictureURL] {
            titleImageView.image = image
        }else {
            handler.downloadPicture(pictureURL)
        }
    }
    let audioPlayer = MPMoviePlayerController()
    func playAudio(urlString : String){
        audioPlayer.contentURL = NSURL(string: urlString)
        audioPlayer.play()
        audioPlayer.beginSeekingBackward()
        //进度条
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
    }
    
    func onUpdate(timer:NSTimer){
        //歌曲总时间
        let duration = audioPlayer.duration
        //歌曲剩余时间
        let backTime = audioPlayer.currentPlaybackTime
        if duration > 0 && backTime > 0 {
            let progressValue = backTime / duration
            
            playProgressView.setProgress(Float(progressValue), animated: true)
            
            let backTimeInt = Int(backTime)
            let min = backTimeInt / 60
            let sec = backTimeInt % 60
            self.timeLabel.text = String(format: "%02d:%02d",  min,sec)
        }
        
    }
    
    func didReceivedImage(url: String, image: UIImage) {
        pictureCache[url] = image
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.titleImageView.image = image
        })
    }
}

