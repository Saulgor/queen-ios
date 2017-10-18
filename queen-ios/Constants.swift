//
//  Constants.swift
//  TuaskAI
//
//  Created by chenze on 2016/10/28.
//  Copyright © 2016年 share. All rights reserved.
//

import Foundation
import SwiftyJSON


typealias CommandResponseBlock =  (AFHTTPRequestOperation?, JSON?, NSError?) -> Void
typealias BooleanResultBlock = (Bool, NSError?) -> Void
typealias ChatMessagesResultBlock = (NSArray?, String , NSError?) -> Void
typealias ChatMessageResultBlock = (Message?, NSError?) -> Void
typealias ChatDetailResultBlock = (ChatDetail?, NSError?) -> Void
typealias BufferResultBlock = (Int, NSError?) -> Void

/* Error */
let ERROR_DOMAIN                     = "Tuask"                    //  String

let ERROR_AUTH                       = 401                       //  Int
let ERROR_EMAIL_MISSING              = 100                       //  Int
let ERROR_EMAIL_FORMAT               = 101                       //  Int
let ERROR_USERNAME_MISSING           = 102                       //  Int
let ERROR_PASSWORD_MISSING           = 103                       //  Int

let HTTP_RESPONSE                    = "response"                //  String
let HTTP_DATA                        = "data"                    //  String
let HTTP_PAGE_SIZE                   = 20                        //  Int

/* HttpMethod */
let HTTPMETHOD_POST                  = "POST"                    //  String
let HTTPMETHOD_PUT                   = "PUT"                     //  String
let HTTPMETHOD_GET                   = "GET"                     //  String
let HTTPMETHOD_DELETE                = "DELETE"                  //  String

/* HttpCode */
let HTTP_SUCCESS                     = 200                       //  Int
let HTTP_AUTH_ERROR                  = 401                       //  Int
let HTTP_SERVER_ERROR                = 500                       //  Int

/* HttpKey */
let HTTP_HEADER_UID                  = "Uid"                     //  String
let HTTP_HEADER_ACCESSTOKEN          = "Access-Token"            //  String
let HTTP_HEADER_CLIENT               = "Client"                  //  String

/* Url */

let API_VERSION                      = "/api/v1"                 //  String
let API_VERSION_2                    = "/api/v2"                 //  String
//-------------------------------------------------------------------------------------------------------------------------------------------------
let TUASK_HOSTNAME = "https://sleepy-meadow-29135.herokuapp.com"

