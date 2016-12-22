//
//  SocketIOManager.swift
//  SChat
//
//  Created by elif ece arslan on 12/21/16.
//  Copyright © 2016 KolektifLabs. All rights reserved.
//

import UIKit


class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    override init () {
        super.init()
    }
    var socket = SocketIOClient(socketURL: NSURL(string:"http://10.20.1.27:3000")! as URL)

    func openConnection() {
        socket.connect()
    }
    func closeConnection() {
        socket.disconnect()
    }
    func connectServerWithNickname(_ nickname: String, completionHandler:@escaping (_ userList:[[String: AnyObject]])-> Void){
//        socket.emit("connectUser", nickname)
//        socket.on("userList") { ( dataArray, ack) -> Void in
//            completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
        socket.on("userList") { (dataArray, acknowledgement) in
            completionHandler(dataArray[0] as! [[String: AnyObject]])
        }
        
    }

    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
  
    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
}
