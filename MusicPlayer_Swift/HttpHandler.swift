//
//  HttpHandler.swift
//  MusicPlayer_Swift
//
//  Created by 张健 on 15/3/25.
//  Copyright (c) 2015年 ForLove. All rights reserved.
//

import Foundation
import UIKit
@objc protocol HttpHandlerDelegate {
    func didReceivedData(json:NSDictionary)
    optional func didReceivedImage(url:String, image:UIImage)
}



class HttpHandler {
    
    var delegate : HttpHandlerDelegate?
    
    let session : NSURLSession
    init(){
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    //查询歌曲列表
    func request(urlString : String){
        if let url = NSURL(string: urlString) {
           let request = NSURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                self.delegate?.didReceivedData(jsonResult)
            })
            task.resume()
        }
        
    }
    
    func downloadPicture(pic:String){
        if let url = NSURL(string: pic) {
            let request = NSURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request, completionHandler: { (data , response, error) -> Void in
                let image = UIImage(data:data)
                self.delegate?.didReceivedImage!(pic, image: image!)
            })
        }
    }
    
    
}