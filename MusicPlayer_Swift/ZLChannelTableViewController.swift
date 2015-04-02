//
//  ZLChannelTableViewController.swift
//  MusicPlayer_Swift
//
//  Created by 张健 on 15/3/25.
//  Copyright (c) 2015年 ForLove. All rights reserved.
//

import UIKit

class ZLChannelTableViewController: UITableViewController, HttpHandlerDelegate{
    //频道数据
    var channelData = [NSDictionary]()
    var handler = HttpHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        handler.delegate = self
        handler.request("http://www.douban.com/j/app/radio/channels")
    }
    
    func didReceivedData(json: NSDictionary) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.channelData = json["channels"] as [NSDictionary]
            self.tableView.reloadData()
        })
        
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return channelData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("ChannelCell", forIndexPath: indexPath) as UITableViewCell
            let rowData = channelData[indexPath.row]
            cell.textLabel?.text = rowData["name"] as? String
            return cell
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
