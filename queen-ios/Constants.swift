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
typealias ChatMessagesResultBlock = (NSArray?, NSError?) -> Void
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
let TUASK_HOSTNAME = "http://lazy-staging.herokuapp.com"
let TUASK_MERCHANT_ACCOUNT = "LazyCOM"
let TUASK_MERCHANT_USERNAME = "ws_391312@Company.LazyLimited"
let TUASK_MERCHANT_PASSWORD = "-FA2/Tfy~h*J{Cv7B~9w[Cw@<"
let TUASK_MERCHANT_PUBLICKEY = "10001|812D5F7B341D426BD10D9636FAEB19168F7A14CF76452B173E7387E1C4C90C58046A7318A02C1579E281870483B8A59B67C4AFDEEDF4FAE2D52F1E7A2F221FF5E080F5C4A8DB74539F0CB4F3ACEB60AA112248AF8301B4DC194F640F7AFFC74C50A8B66F3CE891A96BECBFF11C01DF599A7D3093CBA9904E7445861E9A47F3CF3091AEC952AFAF326C4F46DF64D7D5FD8B4344EFAD5F83B90F9A908BD85313826E6EAC61511FCB91854F31A8D8CA1308FD4B322C6F7D42A8E4520AAD86F84A9A783661BCA351FE5158C745C61388E7A0FD8DDFD3A6B3F5C9377FE71129A7CE44D6954E97C72277166391494106619CA3D5A6D1ED40FEA5032F6718AE62DE93B5"
let TUASK_ADYEN_HOSTNAME = "https://pal-test.adyen.com/pal/adapter/httppost"
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//let TUASK_HOSTNAME = "http://api.lazy.com.hk"
//let TUASK_MERCHANT_ACCOUNT = "LazyCOM"
//let TUASK_MERCHANT_USERNAME = "ws_863996@Company.LazyLimited"
//let TUASK_MERCHANT_PASSWORD = "fUTCp*GV])fg-R>/(EyR~=%G9"
//let TUASK_MERCHANT_PUBLICKEY = "10001|A047BB12930508844328A6BAD8B453ABDBAA8804AD3C23822C12769F7942D9ECF1F7D0B909494D195BF4F791F33EF4C9FC04E2DAB709B800F2471DDFC28BBDC1B93558A0C66768B972F857D172AC425C5A04DBBF812991D81A09478A888C5B1047852C10E547E97DD545E06EB3052EBA2A63A8DB810C8F7DDBCE731E1A2A4F06122BDB83A941999F6A872B6E832DDC9977310441025D18E024647678BDD4DD2FA3098632B419089062E718F4411AE0B4F88971B20660A68CFF3154E4D9D3DF2A15BFC4684E44BD2C506329B42ACB4609C8804E392ED931337E6F7CE84B9B731D06388A0D61E0E35D3A9487FD0EFA2254192C72575F816D883A9582F32B2CCC21"
//let TUASK_ADYEN_HOSTNAME = "https://pal-live.adyen.com/pal/adapter/httppost"
//-------------------------------------------------------------------------------------------------------------------------------------------------

