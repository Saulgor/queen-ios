//
//  Chat.swift
//  ConsumerApp
//
//  Created by Ze Chen on 8/8/2016.
//  Copyright © 2016 sharemedia. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


enum MessageType{
    case Text
    case Image
    case News
    case Stock
}

class Message {
    var message_id:NSNumber = 0
    var message_type:String = ""
    var content:String = ""
    var attachment:String = ""
    var created_at:NSDate = NSDate()
    var custom_content:CustomContent = CustomContent()
    var isFromSocket = false
    
    init() {
        
    }
    
    init(message_type:String,content:String,attachment:String,isFromSocket:Bool) {
        self.message_type = message_type
        self.content = content
        self.attachment = attachment
        self.isFromSocket = isFromSocket
    }
    
    static func postTextMessageWithBlock(chat_id:NSNumber,text:String,block:ChatMessageResultBlock){
        Alamofire.request(TUASK_HOSTNAME + API_VERSION + "").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
}

class ChatDetail {
    var chat_id:NSNumber = 0
}

class CustomContent {
    var type:String = ""
}

class ChatRESTCommand {
    
    ///--------------------------------------
    /// @name Init
    ///--------------------------------------
//    static func _commandWithHTTPPath(path:String?, httpMethod:String?, header:NSDictionary?, parameters:NSDictionary?, data:NSData?, fileDataName:String?) -> ChatRESTCommand{
//        let result = ChatRESTCommand()
//        result.HTTPPath = path
//        result.HTTPMethod = httpMethod
//        result.header = header
//        result.parameters = parameters
//        result.multipartData = data
//        result.fileDataName = fileDataName
//        return result
//    }
//
//    static func fetchChatMessagesCommand(chat_id:NSNumber,offset:Int) -> ChatRESTCommand {
//        return self._commandWithHTTPPath(path: TUASK_HOSTNAME + API_VERSION_2 + "/chats/\(chat_id.intValue)/messages?page=1&offset=\(offset)", httpMethod: HTTPMETHOD_GET, header: nil, parameters: nil, data: nil, fileDataName: nil)
//    }
//
//    static func fetchChatDetailCommand(chat_id:NSNumber) -> ChatRESTCommand {
//        return self._commandWithHTTPPath(path: TUASK_HOSTNAME + API_VERSION_2 + "/chats/\(chat_id.intValue)", httpMethod: HTTPMETHOD_GET, header: nil, parameters: nil, data: nil, fileDataName: nil)
//    }
//
//    static func postMessage(chat_id:NSNumber,text:String) -> ChatRESTCommand {
//        let parameters = ["message[message_type]":"text","message[content]":text]
//        return self._commandWithHTTPPath(path: TUASK_HOSTNAME + API_VERSION_2 + "/chats/\(chat_id.intValue)/send_message", httpMethod: HTTPMETHOD_POST, header: nil, parameters: parameters as NSDictionary, data: nil, fileDataName: nil)
//    }
//
//    static func postMessage(chat_id:NSNumber,image:NSData) -> ChatRESTCommand {
//        let parameters = ["message[message_type]":"image"]
//        return self._commandWithHTTPPath(path: TUASK_HOSTNAME + API_VERSION_2 + "/chats/\(chat_id.intValue)/send_message", httpMethod: HTTPMETHOD_POST, header: nil, parameters: parameters as NSDictionary, data: image, fileDataName: "message[attachment]")
//    }
//
//    static func cancelChat(chat_id:NSNumber) -> ChatRESTCommand {
//        return self._commandWithHTTPPath(path: TUASK_HOSTNAME + API_VERSION_2 + "/chats/\(chat_id.intValue)/cancel", httpMethod: HTTPMETHOD_POST, header: nil, parameters: nil, data: nil, fileDataName: nil)
//    }
}

class ChatModelUtilities {
    static func _fetchChatMessagesFromResponse(json:JSON) -> NSArray{
        if json == nil {
            return NSArray()
        }
        
        let data = json[HTTP_RESPONSE]
        let messages = NSMutableArray()
        for object in data.arrayValue {
            messages.add(_fetchChatMessageFromJSON(object: object))
        }
        return messages
    }
    
    static func _fetchChatMessageFromResponse(data:JSON) -> Message{
        if data == nil {
            return Message()
        }
        
        let object = data[HTTP_RESPONSE]
        return _fetchChatMessageFromJSON(object: object)
    }
    
    static func _fetchChatDetailFromResponse(data:JSON) -> ChatDetail{
        if data == nil {
            return ChatDetail()
        }
        
        let object = data[HTTP_RESPONSE]
        let detail = ChatDetail()
        detail.chat_id = object["id"].numberValue
        return detail
    }
    
    static func _fetchChatMessageFromJSON(object:JSON) -> Message{
        if object == nil {
            return Message()
        }
        
        let message = Message()
        message.message_id = object["id"].numberValue
        message.message_type = object["message_type"].stringValue
        message.content = object["content"].stringValue
        message.attachment = object["attachment"].stringValue
//        message.created_at = NSDate.convertStringToDate(string: object["created_at"].stringValue)!
        message.custom_content = _fetchChatMessageCustomContentFromJSON(object:object["custom_content"])
        
        return message
    }
    
    static func _fetchChatMessageCustomContentFromJSON(object:JSON) -> CustomContent{
        if object == nil {
            return CustomContent()
        }
        let content = CustomContent()
        content.type = object["type"].stringValue
        return content
    }
}
