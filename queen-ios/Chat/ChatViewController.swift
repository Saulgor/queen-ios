//
//  ViewController.swift
//  TableView-Chat
//
//  Created by liujunbin on 16/5/17.
//  Copyright © 2016年 liujunbin. All rights reserved.
//

import UIKit
import SocketRocket
import SwiftyJSON

class ChatViewController: ViewController , UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SRWebSocketDelegate, UIScrollViewDelegate{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContainer1: UIView!
    @IBOutlet weak var scrollViewContainer2: UIView!
    @IBOutlet weak var scrollViewContainer3: UIView!
    
    var refreshControl: UIRefreshControl?
    var refreshing: Bool = false {
        didSet {
            if (self.refreshing) {
                self.refreshControl?.beginRefreshing()
            }
            else {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    var chat_id:NSNumber = 1
    var last_id = ""
    
    var _webSocket:SRWebSocket?
    
    var cover:UIButton!
    
    
    @IBOutlet weak var chatTable: ChatTableView! {
        didSet{
            chatTable.translatesAutoresizingMaskIntoConstraints = false
            chatTable.separatorStyle = .none
            chatTable.backgroundColor = UIColor.ChatBackgroundColor()
            chatTable.estimatedRowHeight = 50
            chatTable.rowHeight = UITableViewAutomaticDimension
            chatTable.rootChatViewController = self
        }
    }
    
    
    @IBOutlet weak var chatTool: ChatInputTool!{
        didSet{
            chatTool.inputTool.delegate = self
            chatTool.translatesAutoresizingMaskIntoConstraints = false
            chatTool.backgroundColor = UIColor.white
        }
    }
    @IBOutlet weak var chatBottomConstraint: NSLayoutConstraint!
    
    var vd : [String : AnyObject] = [String : AnyObject]()
    
    var testString1:String = "Hello"
    var testString2:String = "Anything else?"
    var width1:CGFloat = 0
    var width2:CGFloat = 0
    var button1:UIButton!
    var button2:UIButton!
    
//    @IBOutlet weak var footerContrainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ChatBackgroundColor()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.layer.zPosition = -50
        self.chatTable.addSubview(refreshControl!)
        self.refreshControl?.addTarget(self, action: #selector(ChatViewController.onPullToFresh), for: UIControlEvents.valueChanged)


        cover = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        cover.backgroundColor = UIColor.clear
        cover.isHidden = true
        self.view.addSubview(cover!)
        self.view.bringSubview(toFront: cover)
        cover.addTarget(self, action: #selector(ChatViewController.onCoverTouched), for: .touchUpInside)

        followInit()
    }
    
    func followInit() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ChatViewController.respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ChatViewController.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.scrollView.addGestureRecognizer(swipeLeft)
        self.scrollView.addGestureRecognizer(swipeRight)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.fetchChatMessages), name: NSNotification.Name(rawValue: "ApplicationWillEnterForegroundFetchMessages"), object: nil)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                scrollToLeft()
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                scrollToRight()
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func scrollToLeft(){
        if scrollView.contentOffset.x == 0 {
        }else if scrollView.contentOffset.x == scrollView.contentSize.width/3 {
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        }else if scrollView.contentOffset.x == scrollView.contentSize.width*2/3{
            scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width/3,y: 0), animated: true)
        }
    }
    
    func scrollToRight(){
        if scrollView.contentOffset.x == 0 {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width/3,y: 0), animated: true)
        }else if scrollView.contentOffset.x == scrollView.contentSize.width/3 {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width*2/3,y: 0), animated: true)
        }else if scrollView.contentOffset.x == scrollView.contentSize.width*2/3{
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        createSenderButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reconnect()

        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.isInChatRoom = true

        self.fetchChatMessages()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.isInChatRoom = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _webSocket?.close()
        _webSocket = nil
    }
    
    func createSenderButtons() {
        width1 = testString1.widthWithConstrainedHeight(35, font: UIFont.boldSystemFont(ofSize: 15)) + 40
        width2 = testString2.widthWithConstrainedHeight(35, font: UIFont.boldSystemFont(ofSize: 15)) + 40
        let leading = (chatTool.frame.width - (width1 + width2 + 10))/2
        button1 = UIButton(frame: CGRect(x:leading, y:60, width:width1, height:35))
        button1.setBackgroundImage(UIImage(named: "bubbleRPurple"), for: .normal)
        button1.setTitle(testString1, for: .normal)
        button1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button1.addTarget(self, action: #selector(ChatViewController.onLeftButtonTouched(sender:)), for: .touchUpInside)
        chatTool.addSubview(button1)
        
        button2 = UIButton(frame: CGRect(x:leading + width1 + 10, y:60, width:2, height:35))
        button2.setBackgroundImage(UIImage(named: "bubbleRPurple"), for: .normal)
        button2.setTitle(testString2, for: .normal)
        button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button2.addTarget(self, action: #selector(ChatViewController.onRightButtonTouched(sender:)), for: .touchUpInside)
        chatTool.addSubview(button2)
        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseInOut, animations: {
            self.button1.frame = CGRect(x:leading, y:10, width:self.width1, height:35)
        }) { (succeed) in}
        UIView.animate(withDuration: 0.2, delay: 0.4, options: .curveEaseInOut, animations: {
            self.button2.frame = CGRect(x:leading + self.width1 + 10, y:10, width:self.width2, height:35)
        }) { (succeed) in}
    }
    
    @objc func onLeftButtonTouched(sender:UIButton) {
        
        var height:CGFloat = 0
        for cell in chatTable.visibleCells {
            height = height + cell.frame.height
        }
        self.addBlank(content: testString2)
        
        if height > chatTable.frame.height-10 {
            height = chatTable.frame.height-50
        }
        UIView.animate(withDuration: 0.8, delay: 1, options: .curveEaseInOut, animations: {
            self.button1.frame = CGRect(x:self.chatTool.frame.width - self.width1 - 13, y: -(self.view.frame.height - self.chatTool.frame.height - height - 30), width: self.width1, height:35)
            self.button1.alpha = 0
        }) { (succeed) in
            self.chatTable.data?.removeLastObject()
//            self.chatTable.data?.add(Message(message_type: "text", content: self.testString1, attachment: "",isFromSocket: false))
//            let cell:BlankChatViewCell = self.chatTable.cellForRow(at: IndexPath(row: self.chatTable.data!.count-1, section: 0)) as! BlankChatViewCell
//            cell.data = ChatViewData(message:Message(message_type: "text", content: self.testString1, attachment: "",isFromSocket: false) , role: .Sender)
        }
    }
    
    @objc func onRightButtonTouched(sender:UIButton) {
        
        var height:CGFloat = 0
        for cell in chatTable.visibleCells {
            height = height + cell.frame.height
        }
        self.addBlank(content: testString2)
        
        if height > chatTable.frame.height-10 {
            height = chatTable.frame.height-50
        }
        UIView.animate(withDuration: 0.8, delay: 1, options: .curveEaseInOut, animations: {
            self.button2.frame = CGRect(x:self.chatTool.frame.width - self.width2 - 13, y: -(self.view.frame.height - self.chatTool.frame.height - height - 30), width:self.width2, height:35)
            self.button2.alpha = 0
        }) { (succeed) in
            self.chatTable.data?.removeLastObject()
//            self.chatTable.data?.add(Message(message_type: "text", content: self.testString2, attachment: "",isFromSocket: false))
//            let cell:BlankChatViewCell = self.chatTable.cellForRow(at: IndexPath(row: self.chatTable.data!.count-1, section: 0)) as! BlankChatViewCell
//            cell.data = ChatViewData(message:Message(message_type: "text", content: self.testString2, attachment: "",isFromSocket: false) , role: .Sender)
        }
    }
    
    @objc func onPullToFresh() {
        self.refreshing = true
        if chatTable.data != nil {
            fetchMoreChatMessages(offset: chatTable.data!.count)
        }else{
            fetchChatMessages()
        }
        
    }
    
    @objc func fetchChatMessages() {
//        let array = NSMutableArray()
//        array.add(Message(message_type: "text", content: "An eclectic mix of Lovestruck and Datetix members", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "Hosted at Magnum", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "Complimentary drink included in the ticket price", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "Complimentary drink included in the ticket price", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "Complimentary drink included in the ticket price", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "Complimentary drink included in the ticket price", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "Live DJ", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "A spooky 666 lucky draw", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "A spooky 666 lucky draw", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "A spooky 666 lucky draw", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "A spooky 666 lucky draw", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "A spooky 666 lucky draw", attachment: "",isFromSocket: false))
//        array.add(Message(message_type: "text", content: "A spooky 666 lucky draw", attachment: "",isFromSocket: false))
//        self.chatTable.data = array
//        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.scrollTab), userInfo: nil, repeats: false)
        Message.fetchChatMessagesWithBlock(chat_id: chat_id, last_id: "") { (messages, last_id, error) in
            if error == nil{
                self.last_id = last_id
                self.chatTable.data = NSMutableArray(array: messages!)
                self.chatTable.scrollToBottom(animated: false)
            }
        }
    }
    
    func fetchMoreChatMessages(offset:Int) {
        Message.fetchChatMessagesWithBlock(chat_id:chat_id, last_id: self.last_id) { (messages, last_id, error) in
            if error == nil{
                if let realDatasource:NSMutableArray = NSMutableArray(array: messages!) {
                    let tempDatasource:NSMutableArray = NSMutableArray(array: self.chatTable.data!)
                    realDatasource.addObjects(from: tempDatasource as [AnyObject])
                    self.last_id = last_id
                    self.chatTable.data = realDatasource
                    self.chatTable.scrollToRow(at: IndexPath(row: messages!.count, section:0), at: .top, animated: false)
                }
            }
            self.refreshing = false
        }
    }
    
    //Socket Handling
    func reconnect() {
        _webSocket?.delegate = nil;
        _webSocket?.close();
        
//        _webSocket = SRWebSocket(URL: NSURL(string: "ws://lazy-staging.herokuapp.com/cable"))
//        _webSocket!.delegate = self;
//        _webSocket!.open()
    }
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        print("Websocket Connected")
//        let strChannel = String(format: "{ \"channel\": \"MessagesChannel\", \"chat_id\": \(chat_id.integerValue)}")
//        let parameters = ["command":"subscribe","identifier":strChannel]
//        
//        
//        do {
//            let jsonData = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted)
//            // here "jsonData" is the dictionary encoded in JSON data
//            let datastring = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
//            _webSocket!.send(datastring)
//        } catch let error as NSError {
//            print(error)
//        }
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        print(":( Websocket Failed With Error")
        print(error)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        print(message)
        if let text = message as? String {
            let result = convertStringToDictionary(text: text)!
            if let message = result["message"] as? [String:AnyObject] {
                if let json = message["json"] as? [String:AnyObject] {
                    let result = ChatModelUtilities._fetchChatMessageFromJSON(object: JSON(json))
                    print(json)
                    print(result)
                    
                    var isDuplicate = false
                    if self.chatTable.data != nil {
                        for data in self.chatTable.data! {
                            if let message = data as? Message{
                                if message._id == result._id {
                                    isDuplicate = true
                                }
                            }
                        }
                    }
                    if !isDuplicate {
                        self.chatTable.data?.add(result)
                        self.chatTable.reloadData()
                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.scrollTab), userInfo: nil, repeats: false)
                    }
                    
                    
                }
            }
        }
        
    }
    @IBAction func addTestData(sender: AnyObject) {
        addLoading()
        let triggerTime = (Int64(NSEC_PER_SEC) * 2)
//        dispatch_after(dispatch_time(dispatch_time_t(DispatchTime.now()), triggerTime), dispatch_get_main_queue(), { () -> Void in
//            self.removeLoading()
//            self.chatTable.data?.add(Message(message_type: "text", content: "Only $180! It's going to be an unmissable event, so tell your single friends and reserve your ticket online now: ", attachment: "",isFromSocket: true))
//            self.chatTable.reloadData()
//            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(self.scrollTab), userInfo: nil, repeats: false)
//        })
        
    }
    
    func addLoading() {
//        self.chatTable.data?.add(Message(message_type: "indicator", content: "", attachment: "",isFromSocket: true))
        self.chatTable.reloadData()
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.scrollTab), userInfo: nil, repeats: false)
    }
    
    func removeLoading()  {
        self.chatTable.data?.removeLastObject()
        let indexPath = IndexPath(row: self.chatTable.data!.count, section: 0)
        self.chatTable.deleteRows(at: [indexPath], with: .left)
    }
    
    func addBlank(content:String) {
//        self.chatTable.data?.add(Message(message_type: "blank", content: content, attachment: "",isFromSocket: true))
        self.chatTable.reloadData()
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.scrollTab), userInfo: nil, repeats: false)
    }
    
    func removeBlank()  {
        self.chatTable.data?.removeLastObject()
        let indexPath = IndexPath(row: self.chatTable.data!.count, section: 0)
        self.chatTable.deleteRows(at: [indexPath], with: .right)
    }
    
    func animateTable() {
        
        let cells = chatTable.visibleCells
        let tableHeight: CGFloat = chatTable.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("WebSocket closed")
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceivePong pongPayload: NSData!) {
        print("WebSocket received pong")
    }
    
    //
    
    
    @objc func onCoverTouched(){
        self.view.endEditing(true)
        removeCover()
    }
    
    func addCover() {
        cover.isHidden = false
    }
    
    func removeCover() {
        cover.isHidden = true
    }
    
    
    func renderTableView(){
        if let txt = chatTool.inputTool.text {
            Message.postTextMessageWithBlock(chat_id: chat_id, text: txt, block: { (message, error) in
                self.chatTool.inputTool.text = ""
                self.chatTable.data?.add(message)
                self.chatTable.reloadData()
                Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.scrollTab), userInfo: nil, repeats: false)
            })
            
        }
        
    }
    
    func renderImageTableView(){
//        chatTool.inputTool.resignFirstResponder()
    }
    
    func postImage(image:UIImage) {
//        Message.postImageMessageWithBlock(chat_id, image: UIImagePNGRepresentation(image)!, block: { (message, error) in
//        })
    }
    
    @objc func scrollTab(){
        chatTable.scrollToBottom(animated: true)
    }
    
    
    //
    
    @objc func keyboardWillShow(notification:NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.addCover()
                //self.view.frame.origin.y =  -keyboardSize.height + 64
                chatBottomConstraint.constant = keyboardSize.height
                chatTable.scrollToBottom(animated: true)
                // ...
            }
        }
    }
    
    @objc func keyboardDidShow(notification:NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.addCover()
                //self.view.frame.origin.y =  -keyboardSize.height + 64
                chatBottomConstraint.constant = keyboardSize.height
                chatTable.scrollToBottom(animated: true)
                // ...
            }
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.removeCover()
                //                self.view.frame.origin.y = 64
                chatBottomConstraint.constant = 0
                // ...
            }
        }
    }
    
}

extension ChatViewController {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.renderTableView()
        return false
    }
    
    
}



