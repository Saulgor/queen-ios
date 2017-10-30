//
//  member.swift
//  queen-ios
//
//  Created by user on 16/10/2017.
//  Copyright © 2017 saulgor. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Member: Base {
    var _id:String = ""
    var mid:NSNumber = 0
    var uid:String = ""
    var name:String = ""
    var email:String = ""
    var avator:String = ""
    
    
    static func fetchMemberWithBlock(uid:String, block:@escaping MemberResultBlock){
        let params: Parameters = [
            "uid": uid
        ]
        Alamofire.request(TUASK_HOSTNAME + API_VERSION + "/members/" + uid, method: .get, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            switch response.result {
            case .success:
                if let jsonResponse = response.result.value {
                    print(jsonResponse) // serialized json response
                    let json = JSON(jsonResponse)
                    block(MemberModelUtilities._fetchMemberFromResponse(json: json), nil)
                }
                
            case .failure:
                block(Member(), nil)
            }
        }
    }
}

class MemberModelUtilities {
    
    static func _fetchMemberFromResponse(json:JSON) -> Member{
        if json == JSON.null {
            return Member()
        }
        
        let object = json[HTTP_DATA]
        return _fetchMemberFromJSON(object: object)
    }
    static func _fetchMemberFromJSON(object:JSON) -> Member{
        if object == JSON.null {
            return Member()
        }
        
        let member = Member()
        member._id = object["_id"]["$oid"].stringValue
        member.mid = object["mid"].numberValue
        member.uid = object["uid"].stringValue
        member.name = object["name"].stringValue
        member.email = object["email"].stringValue
        member.avator = object["avator"].stringValue
        
        return member
    }
}
