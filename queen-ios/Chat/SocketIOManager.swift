//
//  SocketIOManager.swift
//  queen-ios
//
//  Created by user on 19/10/2017.
//  Copyright © 2017 saulgor. All rights reserved.
//

import Foundation
import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "https://sleepy-meadow-29135.herokuapp.com")!, config: [.nsp("/chat")])
    
    
    override init() {
        super.init()
    }
    
    
    func establishConnection() {
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        
        socket.on(clientEvent: .error) {data, ack in
            print("socket error")
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnect")
            
        }
        
        socket.on(clientEvent: .reconnect) {data, ack in
            print("socket reconnect")
        }
        
        socket.on(clientEvent: .reconnectAttempt) {data, ack in
            print("socket reconnectAttempt")
        }
        
        socket.on(clientEvent: .statusChange) {data, ack in
            print("socket statusChange")
        }
        
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    
    func registerToServerWithUserId(userId: String, completionHandler: (_ succeed:Bool) -> Void) {
        socket.emit("register", ["user": userId])
        completionHandler(true)
        listenForOtherMessages()
    }
    
    
    func exitChatWithChat(chat_id: NSNumber, completionHandler: () -> Void) {
        socket.emit("leave", ["room": chat_id.intValue])
        completionHandler()
    }
    
    
    func sendMessage(chat_id: NSNumber, message: String, withNickname nickname: String) {
        socket.emit("my room event", ["room": chat_id.intValue, "data": message])
    }
    
    private func listenForOtherMessages() {
        socket.on("my response") { (dataArray, socketAck) -> Void in
            print(dataArray)
        }
    }
    
    
    func sendStartTypingMessage(nickname: String) {
        socket.emit("startType", nickname)
    }
    
    
    func sendStopTypingMessage(nickname: String) {
        socket.emit("stopType", nickname)
    }
}
