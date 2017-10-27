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
    var _id:String = ""
    var chat_id:NSNumber = 0
    var sender_id:String = ""
    var receiver_id:String = ""
    var type:String = ""
    var created_at:NSDate = NSDate()
    var custom_content:CustomContent = CustomContent()
    
    init() {
        
    }
    
    init(_id:String, chat_id:NSNumber, sender_id:String, receiver_id:String, type:String) {
        self._id = _id;
        self.chat_id = chat_id;
        self.sender_id = sender_id;
        self.receiver_id = receiver_id;
        self.type = type;
    }
    
    static func postTextMessageWithBlock(chat_id:String, user_id:String, text:String,block:@escaping ChatMessageResultBlock){
        let params: Parameters = [
            "text": text,
            "chat_id": chat_id,
            "user_id": user_id
        ]
        Alamofire.request(TUASK_HOSTNAME + API_VERSION + "/messages", method: .post, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            switch response.result {
            case .success:
                if let jsonResponse = response.result.value {
                    print(jsonResponse) // serialized json response
                    let json = JSON(jsonResponse)
                    block(ChatModelUtilities._fetchChatMessageFromResponse(json: json), nil)
                }
                
            case .failure:
                block(nil, nil)
            }
        }
    }
    
    
    static func fetchChatMessagesWithBlock(chat_id:String, last_id:String, block:@escaping ChatMessagesResultBlock){
        let params: Parameters = [
            "last_id": last_id,
            "page_size": HTTP_PAGE_SIZE,
            "chat_id": chat_id
        ]
        Alamofire.request(TUASK_HOSTNAME + API_VERSION + "/messages", method: .get, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            switch response.result {
            case .success:
                if let jsonResponse = response.result.value {
                    print(jsonResponse) // serialized json response
                    let json = JSON(jsonResponse)
                    block(ChatModelUtilities._fetchChatMessagesFromResponse(json: json), ChatModelUtilities._fetchChatMessagesLastIdFromResponse(json: json), nil)
                }
                
            case .failure:
                block(NSArray(), "", nil)
            }
        }
    }
}

class ChatDetail {
    var chat_id:NSNumber = 0
}

class CustomContent {
    var text:String = ""
    var news:NSArray?
}

class ChatModelUtilities {
    static func _fetchChatMessagesLastIdFromResponse(json:JSON) -> String{
        if json == JSON.null {
            return ""
        }
        
        let data = json[HTTP_DATA]["last_id"]["$oid"].stringValue
        return data
    }
    
    static func _fetchChatMessagesFromResponse(json:JSON) -> NSArray{
        if json == JSON.null {
            return NSArray()
        }
        
        let data = json[HTTP_DATA]["messages"]
        let messages = NSMutableArray()
        for object in data.arrayValue {
            messages.add(_fetchChatMessageFromJSON(object: object))
        }
        return messages
    }
    
    static func _fetchChatMessageFromResponse(json:JSON) -> Message{
        if json == JSON.null {
            return Message()
        }
        
        let object = json[HTTP_DATA]
        return _fetchChatMessageFromJSON(object: object)
    }
    
    static func _fetchChatDetailFromResponse(data:JSON) -> ChatDetail{
        if data == JSON.null {
            return ChatDetail()
        }
        
        let object = data[HTTP_RESPONSE]
        let detail = ChatDetail()
        detail.chat_id = object["id"].numberValue
        return detail
    }
    
    static func _fetchChatMessageFromJSON(object:JSON) -> Message{
        if object == JSON.null {
            return Message()
        }
        
        let message = Message()
        message._id = object["_id"]["$oid"].stringValue
        message.chat_id = object["chat_id"].numberValue
        message.sender_id = object["sender_id"].stringValue
        message.receiver_id = object["receiver_id"].stringValue
        message.type = object["type"].stringValue
//        message.created_at = NSDate.convertStringToDate(string: object["created_at"].stringValue)!
        message.custom_content = _fetchChatMessageCustomContentFromJSON(object:object["content"], type: message.type)
        
        return message
    }
    
    
    static func _fetchChatMessageFromSocketJSON(object:JSON) -> Message?{
        if object == JSON.null {
            return Message()
        }
        var message:Message?
        let type = object.arrayValue[0]["type"].stringValue
        let act = object.arrayValue[0]["act"].stringValue
        switch type {
        case "private_message":
            if act == "pm" {
                let text = object.arrayValue[0]["data"]["text"].stringValue
                let from = object.arrayValue[0]["data"]["from"].stringValue
                let to = object.arrayValue[0]["data"]["to"].stringValue
                message = Message(_id: "", chat_id: 0, sender_id: from, receiver_id: to, type: "text")
                message!.custom_content.text = text
            }
        case "private_message_success":
            if act == "pm" {
                let text = object.arrayValue[0]["data"]["text"].stringValue
                let from = object.arrayValue[0]["data"]["from"].stringValue
                let to = object.arrayValue[0]["data"]["to"].stringValue
                message = Message(_id: "", chat_id: 0, sender_id: from, receiver_id: to, type: "text")
                message!.custom_content.text = text
            }
        default:
            break
        }
        
        return message
    }
    
    static func _fetchChatMessageCustomContentFromJSON(object:JSON, type:String) -> CustomContent{
        if object == JSON.null {
            return CustomContent()
        }
        let content = CustomContent()
        switch type {
        case "text":
            content.text = object["text"].stringValue
            break
        case "news":
            let newsArray = NSMutableArray()
            for item in object["news"].arrayValue {
                let news = News()
                news.title = item["title"].stringValue
                news.url = item["url"].stringValue
                news.detail = item["detail"].stringValue
                news.source = item["source"].stringValue
                news.created_at = item["created_at"].stringValue
                news.website = item["website"].stringValue
                newsArray.add(news)
            }
            content.news = newsArray
            break
        case "stock":
            break
        default:
            break
        }
        
        return content
    }
}
