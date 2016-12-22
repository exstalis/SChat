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
}
