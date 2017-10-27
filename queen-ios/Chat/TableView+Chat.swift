//
//  TableView+Chat.swift
//  TableView-Chat
//
//  Created by Saul on 16/7/23.
//  Copyright © 2016年 Saul. All rights reserved.
//

import UIKit
import SDWebImage

extension UIFont {

    static var FontStyleNomarl : UIFont {
        return UIFont.systemFont(ofSize: 16)//UIFont(name: "ArialRoundedMT-Light", size: 16)!
    }
    
    static var FontStyleBold : UIFont {
        return UIFont.boldSystemFont(ofSize: 16)//UIFont(name: "ArialRoundedMTBold", size: 16)!
    }

    static var FontTextStyleSubheadline: UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
    }
    
    static var ChatTitleFontStyleNomarl : UIFont {
        return UIFont.boldSystemFont(ofSize: 12)//UIFont(name: "ArialRoundedMT-Light", size: 16)!
    }
    
    static var NewsFontStyleNomarl : UIFont {
        return UIFont.systemFont(ofSize: 10)//UIFont(name: "ArialRoundedMT-Light", size: 16)!
    }
}


enum Role{
    case Sender //发送者
    case Receiver  //接收者
}

enum Type{
    case text //文本
    case photo  //图片
    case plan
}


class ChatViewData: NSObject {
    var message:Message = Message()
    var role : Role = Role.Sender
    
    init(message:Message ,role:Role) {
        self.message = message
        self.role = role
    }
    
}



class ChatTableView : UITableView ,UITableViewDataSource , UITableViewDelegate{
    var rootChatViewController:ChatViewController!
    var displayPhotos:NSArray = NSArray()
    
    var current_user_id:String = "queen@test.com"
    
    var data : NSMutableArray? {
        didSet {
            print("didSet is :\(data)")
            guard let d = data, d.count > 0 else {
                return
            }
            self.reloadData()
        }
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        followInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }

    func followInit(){
        
        self.register(MessageChatViewCell.self, forCellReuseIdentifier: "MessageChatViewCell")
        self.register(PhotoChatViewCell.self, forCellReuseIdentifier: "PhotoChatViewCell")
        self.register(ActivityIndicatorChatViewCell.self, forCellReuseIdentifier: "ActivityIndicatorChatViewCell")
        self.register(BlankChatViewCell.self, forCellReuseIdentifier: "BlankChatViewCell")
        self.register(NewsChatViewCell.self, forCellReuseIdentifier: "NewsChatViewCell")
        self.dataSource = self
        self.delegate = self
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: IndexPath) -> NSIndexPath? {
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let d = data{
            let dc = d[indexPath.row] as! Message
            let type = dc.type
            if type == "text" {
                let role = dc.sender_id == current_user_id ? Role.Sender : Role.Receiver
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageChatViewCell", for: indexPath) as! MessageChatViewCell
                cell.message_type = type
                cell.role = role
                cell.data = ChatViewData(message:dc , role: role)
                return cell
            }else if type == "news"{
                let role = dc.sender_id == current_user_id ? Role.Sender : Role.Receiver
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsChatViewCell", for: indexPath) as! NewsChatViewCell
                cell.message_type = type
                cell.role = role
                cell.data = ChatViewData(message:dc , role: role)
//                cell.contentImageButton.addTarget(self, action: #selector(ChatTableView.onImageDisplay(_:)), forControlEvents: .TouchUpInside)
                cell.contentImage.tag = indexPath.row
                return cell
            }else if type == "indicator"{
                let role = Role.Receiver
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityIndicatorChatViewCell", for: indexPath) as! ActivityIndicatorChatViewCell
                cell.message_type = type
                cell.role = role
                cell.data = ChatViewData(message:dc , role: role)
                return cell
            }else if type == "blank" {
                let role = Role.Sender
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlankChatViewCell", for: indexPath) as! BlankChatViewCell
                cell.message_type = type
                cell.role = role
                cell.data = ChatViewData(message:dc , role: role)
                return cell
            }else{
                return UITableViewCell()
            }
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let chatViewCell:ChatViewCell = cell as! ChatViewCell
        if indexPath.row == self.data!.count-1 && chatViewCell.message_type != "blank" && chatViewCell.role != .Sender{
            cell.transform = CGAffineTransform(translationX: -cell.frame.width, y: 0)
            UIView.animate(withDuration: 0.8, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
        }
        
    }
    
    func onImageDisplay(sender:UIButton) {
        let message = self.data![sender.tag] as! Message
    }
    func onCheckOut(sender:UIButton) {
        
        
    }
}

class ChatViewCell:UITableViewCell{
    var message_type:String!
    var role:Role!
}


class MessageChatViewCell: ChatViewCell {
    var data:ChatViewData? {
        didSet {
            self.backgroundColor = UIColor.clear
            self.headerImgView.removeFromSuperview()
            self.contentLbl.removeFromSuperview()
            self.bubbleImgView.removeFromSuperview()
            self.contentView.addSubview(self.headerImgView)
            self.contentView.addSubview(self.bubbleImgView)
            self.bubbleImgView.addSubview(self.contentLbl)
            //            self.selectionStyle = .none
            //将data模型中的数据给头像、内容、气泡视图

            self.headerImgView.image = UIImage(named: "penguin")
            self.bubbleImgView.image = data?.role == Role.Sender ? UIImage(named: "bubbleRGrey") : UIImage(named: "bubbleLWhite")
            self.contentLbl.text = data?.message.custom_content.text
            self.contentLbl.textColor = UIColor.black
            self.contentLbl.textAlignment = data?.role == Role.Sender ? NSTextAlignment.left : NSTextAlignment.left

            //2.设置约束
            let vd = ["headerImgView": self.headerImgView, "content": self.contentLbl, "bubble": self.bubbleImgView] as [String : Any]
            let header_constraint_H_Format = data?.role == Role.Sender ? "[headerImgView(0)]-5-|" : "|-5-[headerImgView(30)]"
            let header_constraint_V_Format = data?.role == Role.Sender ? "V:[headerImgView(30)]-8-|" : "V:[headerImgView(30)]-8-|"
            let bubble_constraint_H_Format = data?.role == Role.Sender ? "|-(>=10)-[bubble]-10-[headerImgView]" : "[headerImgView]-10-[bubble]-(>=10)-|"
            let bubble_constraint_V_Format = data?.role == Role.Sender ? "V:|-8-[bubble(>=35)]-8-|" : "V:|-8-[bubble(>=35)]-8-|"
            let content_constraint_H_Format = data?.role == Role.Sender ? "|-10-[content]-16-|" : "|-16-[content]-10-|"
            let content_constraint_V_Format = data?.role == Role.Sender ? "V:|-5-[content]-5-|" : "V:|-5-[content]-5-|"


            let header_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:header_constraint_H_Format, options: [], metrics: nil, views: vd)
            let header_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:header_constraint_V_Format, options: [], metrics: nil, views: vd)

            let bubble_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:bubble_constraint_H_Format, options: [], metrics: nil, views: vd)
            let bubble_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:bubble_constraint_V_Format, options: [], metrics: nil, views: vd)

            let content_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:content_constraint_H_Format, options: [], metrics: nil, views: vd)
            let content_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:content_constraint_V_Format, options: [], metrics: nil, views: vd)

            self.contentView.addConstraints(header_constraint_H)
            self.contentView.addConstraints(header_constraint_V)
            self.contentView.addConstraints(bubble_constraint_H)
            self.contentView.addConstraints(bubble_constraint_V)
            self.contentView.addConstraints(content_constraint_H)
            self.contentView.addConstraints(content_constraint_V)

        }
    }
    //头像
    lazy var headerImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
        return v
    }()
    //内容
    lazy var contentLbl : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.FontStyleNomarl
        return v
    }()
    //气泡
    lazy var bubbleImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        followInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    
    func followInit(){
        self.selectionStyle = .none
    }
    
}


class NewsChatViewCell: ChatViewCell {
    var data:ChatViewData? {
        didSet {
            self.backgroundColor = UIColor.clear
            self.headerImgView.removeFromSuperview()
            self.contentNews.removeFromSuperview()
            self.bubbleImgView.removeFromSuperview()
            self.contentLbl.removeFromSuperview()
            self.contentTitle.removeFromSuperview()
            self.newsTitleLbl.removeFromSuperview()
            self.newsDetailLbl.removeFromSuperview()
            self.contentView.addSubview(self.headerImgView)
            self.contentView.addSubview(self.bubbleImgView)
            self.bubbleImgView.addSubview(self.contentNews)
            self.bubbleImgView.addSubview(self.contentLbl)
            self.bubbleImgView.addSubview(self.contentTitle)
            self.contentNews.addSubview(self.newsTitleLbl)
            self.contentNews.addSubview(self.newsDetailLbl)
            self.contentNews.addSubview(self.contentImage)
            //            self.selectionStyle = .none
            //将data模型中的数据给头像、内容、气泡视图
            //            self.contentView.isHidden = data!.message.isFromSocket
            
            self.headerImgView.image = UIImage(named: "penguin")
            self.bubbleImgView.image = data?.role == Role.Sender ? UIImage(named: "bubbleRGrey") : UIImage(named: "bubbleLWhite")
            //            if data?.message.attachment.characters.count > 0 {
            //                self.contentImage.sd_setImage(with: NSURL(string: data!.message.attachment) as! URL)
            //            }else{
            //                self.contentImage.image = UIImage(named: "adidas")
            //            }
            let news = data!.message.custom_content.news
            if news != nil && news!.count > 0 {
                self.newsTitleLbl.text = (news![0] as! News).title
                self.newsDetailLbl.text = (news![0] as! News).detail
                switch (news![0] as! News).website {
                case "yahoonews":
                    self.contentTitle.textColor = UIColor.yahooColor()
                    self.contentTitle.text = "Yahoo"
                    self.contentImage.image = UIImage(named:"yahoo")
                    break
                default:
                    break
                }
            }
            
            
            //2.设置约束
            let vd = ["headerImgView": self.headerImgView, "content": self.contentNews, "bubble": self.bubbleImgView, "contentImageButton":self.contentImage, "contentTitle":self.contentTitle, "contentLbl":self.contentLbl, "newsTitleLbl":self.newsTitleLbl, "newsDetailLbl":self.newsDetailLbl] as [String : Any]
            let header_constraint_H_Format = data?.role == Role.Sender ? "[headerImgView(0)]-5-|" : "|-5-[headerImgView(30)]"
            let header_constraint_V_Format = data?.role == Role.Sender ? "V:[headerImgView(30)]-8-|" : "V:[headerImgView(30)]-8-|"
            let bubble_constraint_H_Format = data?.role == Role.Sender ? "|-80-[bubble]-10-[headerImgView]" : "[headerImgView]-10-[bubble]-80-|"
            let bubble_constraint_V_Format = data?.role == Role.Sender ? "V:|-8-[bubble(>=35)]-8-|" : "V:|-8-[bubble(>=35)]-8-|"
            let content_constraint_H_Format = data?.role == Role.Sender ? "|-5-[content]-12-|" : "|-12-[content]-5-|"
            let content_constraint_V_Format = data?.role == Role.Sender ? "V:|-5-[contentTitle(17)]-5-[content(80)]-6-[contentLbl]-5-|" : "V:|-5-[contentTitle(17)]-5-[content(80)]-6-[contentLbl]-5-|"
            let contentlbl_constraint_H_Format = data?.role == Role.Sender ? "|-5-[contentLbl]-12-|" : "|-12-[contentLbl]-5-|"
            let contenttitle_constraint_H_Format = data?.role == Role.Sender ? "|-10-[contentTitle]-17-|" : "|-17-[contentTitle]-10-|"
            let newstitle_constraint_H_Format = data?.role == Role.Sender ? "|-80-[newsTitleLbl]-5-|" : "|-5-[newsTitleLbl]-80-|"
            let newsdetail_constraint_H_Format = data?.role == Role.Sender ? "|-80-[newsDetailLbl]-5-|" : "|-5-[newsDetailLbl]-80-|"
            let news_constraint_V_Format = data?.role == Role.Sender ? "V:|-5-[newsTitleLbl(17)]-2-[newsDetailLbl]-5-|" : "V:|-5-[newsTitleLbl(17)]-2-[newsDetailLbl]-5-|"

            let content_button_constraint_H_Format = data?.role == Role.Sender ? "|[contentImageButton(70)]" : "[contentImageButton(70)]|"
            let content_button_constraint_V_Format = data?.role == Role.Sender ? "V:|[contentImageButton(80)]|" : "V:|[contentImageButton(80)]|"
            
            
            let header_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:header_constraint_H_Format, options: [], metrics: nil, views: vd)
            let header_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:header_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let bubble_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:bubble_constraint_H_Format, options: [], metrics: nil, views: vd)
            let bubble_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:bubble_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let content_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:content_constraint_H_Format, options: [], metrics: nil, views: vd)
            let content_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:content_constraint_V_Format, options: [], metrics: nil, views: vd)
            let contentlbl_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:contentlbl_constraint_H_Format, options: [], metrics: nil, views: vd)
            let contenttitle_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:contenttitle_constraint_H_Format, options: [], metrics: nil, views: vd)
            
            let newstitle_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:newstitle_constraint_H_Format, options: [], metrics: nil, views: vd)
            let news_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:newsdetail_constraint_H_Format, options: [], metrics: nil, views: vd)
            let news_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:news_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let content_button_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:content_button_constraint_H_Format, options: [], metrics: nil, views: vd)
            let content_button_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:content_button_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            self.contentView.addConstraints(header_constraint_H)
            self.contentView.addConstraints(header_constraint_V)
            self.contentView.addConstraints(bubble_constraint_H)
            self.contentView.addConstraints(bubble_constraint_V)
            self.contentView.addConstraints(content_constraint_H)
            self.contentView.addConstraints(content_constraint_V)
            self.contentView.addConstraints(contentlbl_constraint_V)
            self.contentView.addConstraints(contenttitle_constraint_V)
            self.contentView.addConstraints(newstitle_constraint_V)
            self.contentView.addConstraints(news_constraint_V)
            self.contentView.addConstraints(news_constraint_H)
            self.contentView.addConstraints(content_button_constraint_H)
            self.contentView.addConstraints(content_button_constraint_V)
            
        }
    }
    //头像
    lazy var headerImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
        return v
    }()
    //内容
    lazy var contentNews : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.isUserInteractionEnabled = true
        v.backgroundColor = UIColor.newsContentBackgroundColor()
        return v
    }()
    //内容
    lazy var contentTitle : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.ChatTitleFontStyleNomarl
        return v
    }()
    //内容
    lazy var contentLbl : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.FontStyleNomarl
        v.numberOfLines = 3
        return v
    }()
    
    
    //内容
    lazy var newsTitleLbl : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.NewsFontStyleNomarl
        v.textColor = UIColor.black
        return v
    }()
    
    //内容
    lazy var newsDetailLbl : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.NewsFontStyleNomarl
        v.textColor = UIColor.newsGrayTextColor()
        return v
    }()

    //内容
    lazy var contentImage : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    //气泡
    lazy var bubbleImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        followInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    
    func followInit(){
        self.selectionStyle = .none
    }
    
}


class PhotoChatViewCell: ChatViewCell {
    var data:ChatViewData? {
        didSet {
            self.backgroundColor = UIColor.clear
            self.headerImgView.removeFromSuperview()
            self.contentImage.removeFromSuperview()
            self.bubbleImgView.removeFromSuperview()
            self.contentView.addSubview(self.headerImgView)
            self.contentView.addSubview(self.bubbleImgView)
            self.bubbleImgView.addSubview(self.contentImage)
            self.contentImage.addSubview(self.contentImageButton)
            //            self.selectionStyle = .none
            //将data模型中的数据给头像、内容、气泡视图
//            self.contentView.isHidden = data!.message.isFromSocket
            
            self.headerImgView.image = UIImage()
            self.bubbleImgView.image = data?.role == Role.Sender ? UIImage(named: "bubbleRGrey") : UIImage(named: "bubbleLWhite")
//            if data?.message.attachment.characters.count > 0 {
//                self.contentImage.sd_setImage(with: NSURL(string: data!.message.attachment) as! URL)
//            }else{
//                self.contentImage.image = UIImage(named: "adidas")
//            }
            
            //2.设置约束
            let vd = ["headerImgView": self.headerImgView, "content": self.contentImage, "bubble": self.bubbleImgView,"contentImageButton":self.contentImageButton] as [String : Any]
            let header_constraint_H_Format = data?.role == Role.Sender ? "[headerImgView(0)]-5-|" : "|-5-[headerImgView(30)]"
            let header_constraint_V_Format = data?.role == Role.Sender ? "V:[headerImgView(30)]-8-|" : "V:[headerImgView(30)]-8-|"
            let bubble_constraint_H_Format = data?.role == Role.Sender ? "[bubble(200)]-10-[headerImgView]" : "[headerImgView]-10-[bubble(200)]"
            let bubble_constraint_V_Format = data?.role == Role.Sender ? "V:|-8-[bubble(200)]-8-|" : "V:|-8-[bubble(200)]-8-|"
            let content_constraint_H_Format = data?.role == Role.Sender ? "|-10-[content]-16-|" : "|-16-[content]-10-|"
            let content_constraint_V_Format = data?.role == Role.Sender ? "V:|-5-[content]-5-|" : "V:|-5-[content]-5-|"
            let content_button_constraint_H_Format = data?.role == Role.Sender ? "|[contentImageButton]|" : "|[contentImageButton]|"
            let content_button_constraint_V_Format = data?.role == Role.Sender ? "V:|[contentImageButton]|" : "V:|[contentImageButton]|"
            
            
            let header_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:header_constraint_H_Format, options: [], metrics: nil, views: vd)
            let header_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:header_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let bubble_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:bubble_constraint_H_Format, options: [], metrics: nil, views: vd)
            let bubble_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:bubble_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let content_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:content_constraint_H_Format, options: [], metrics: nil, views: vd)
            let content_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:content_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let content_button_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:content_button_constraint_H_Format, options: [], metrics: nil, views: vd)
            let content_button_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:content_button_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            self.contentView.addConstraints(header_constraint_H)
            self.contentView.addConstraints(header_constraint_V)
            self.contentView.addConstraints(bubble_constraint_H)
            self.contentView.addConstraints(bubble_constraint_V)
            self.contentView.addConstraints(content_constraint_H)
            self.contentView.addConstraints(content_constraint_V)
            self.contentView.addConstraints(content_button_constraint_H)
            self.contentView.addConstraints(content_button_constraint_V)
            
        }
    }
    //头像
    lazy var headerImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
        return v
    }()
    //内容
    lazy var contentImage : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.contentMode = .scaleAspectFill
        v.isUserInteractionEnabled = true
        return v
    }()
    //内容
    lazy var contentImageButton : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    //气泡
    lazy var bubbleImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        followInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    
    func followInit(){
        self.selectionStyle = .none
    }
    
}

class ActivityIndicatorChatViewCell: ChatViewCell {
    var data:ChatViewData? {
        didSet {
            self.backgroundColor = UIColor.clear
            self.headerImgView.removeFromSuperview()
            self.content.removeFromSuperview()
            self.bubbleImgView.removeFromSuperview()
            self.contentView.addSubview(self.headerImgView)
            self.contentView.addSubview(self.bubbleImgView)
            self.bubbleImgView.addSubview(self.content)
            //            self.selectionStyle = .none
            //将data模型中的数据给头像、内容、气泡视图
            
            self.headerImgView.image = UIImage()
            self.bubbleImgView.image = data?.role == Role.Sender ? UIImage(named: "bubbleRGrey") : UIImage(named: "bubbleLWhite")
            
            //2.设置约束
            let vd = ["headerImgView": self.headerImgView, "content": self.content, "bubble": self.bubbleImgView] as [String : Any]
            let header_constraint_H_Format = data?.role == Role.Sender ? "[headerImgView(0)]-5-|" : "|-5-[headerImgView(0)]"
            let header_constraint_V_Format = data?.role == Role.Sender ? "V:[headerImgView(30)]-8-|" : "V:[headerImgView(30)]-8-|"
            let bubble_constraint_H_Format = data?.role == Role.Sender ? "|-(>=10)-[bubble]-10-[headerImgView]" : "[headerImgView]-10-[bubble]-(>=10)-|"
            let bubble_constraint_V_Format = data?.role == Role.Sender ? "V:|-8-[bubble(>=35)]-8-|" : "V:|-8-[bubble(>=35)]-8-|"
            let content_constraint_H_Format = data?.role == Role.Sender ? "|-10-[content(50)]-16-|" : "|-16-[content(50)]-10-|"
            let content_constraint_V_Format = data?.role == Role.Sender ? "V:|-0-[content(40)]-0-|" : "V:|-0-[content(40)]-0-|"
            
            
            let header_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:header_constraint_H_Format, options: [], metrics: nil, views: vd)
            let header_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:header_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let bubble_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:bubble_constraint_H_Format, options: [], metrics: nil, views: vd)
            let bubble_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:bubble_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let content_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:content_constraint_H_Format, options: [], metrics: nil, views: vd)
            let content_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:content_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            self.contentView.addConstraints(header_constraint_H)
            self.contentView.addConstraints(header_constraint_V)
            self.contentView.addConstraints(bubble_constraint_H)
            self.contentView.addConstraints(bubble_constraint_V)
            self.contentView.addConstraints(content_constraint_H)
            self.contentView.addConstraints(content_constraint_V)
            
        }
    }
    //头像
    lazy var headerImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
        return v
    }()
    //内容
    lazy var content : DotsLoader = {
        let v = DotsLoader()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.tintColor = UIColor.gray
        return v
    }()
    //气泡
    lazy var bubbleImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        followInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    
    func followInit(){
        self.selectionStyle = .none
    }
    
}

class BlankChatViewCell: ChatViewCell {
    
    var data:ChatViewData? {
        didSet {
            self.backgroundColor = UIColor.clear
            self.headerImgView.removeFromSuperview()
            self.contentLbl.removeFromSuperview()
            self.bubbleImgView.removeFromSuperview()
            self.contentView.addSubview(self.headerImgView)
            self.contentView.addSubview(self.bubbleImgView)
            self.bubbleImgView.addSubview(self.contentLbl)
            //            self.selectionStyle = .none
            //将data模型中的数据给头像、内容、气泡视图
            
            self.headerImgView.image = UIImage()
            if data?.message.type == "blank" {
                self.bubbleImgView.image = UIImage()
                self.contentLbl.textColor = UIColor.clear
            }else{
                self.bubbleImgView.image = UIImage(named: "bubbleRGrey")
                self.contentLbl.textColor = UIColor.black
            }
            
            self.contentLbl.text = data?.message.custom_content.text
            self.contentLbl.textAlignment = data?.role == Role.Sender ? NSTextAlignment.left : NSTextAlignment.left
            
            //2.设置约束
            let vd = ["headerImgView": self.headerImgView, "content": self.contentLbl, "bubble": self.bubbleImgView] as [String : Any]
            let header_constraint_H_Format = data?.role == Role.Sender ? "[headerImgView(0)]-5-|" : "|-5-[headerImgView(0)]"
            let header_constraint_V_Format = data?.role == Role.Sender ? "V:[headerImgView(30)]-8-|" : "V:[headerImgView(30)]-8-|"
            let bubble_constraint_H_Format = data?.role == Role.Sender ? "|-(>=10)-[bubble]-10-[headerImgView]" : "[headerImgView]-10-[bubble]-(>=10)-|"
            let bubble_constraint_V_Format = data?.role == Role.Sender ? "V:|-8-[bubble(>=35)]-8-|" : "V:|-8-[bubble(>=35)]-8-|"
            let content_constraint_H_Format = data?.role == Role.Sender ? "|-10-[content]-16-|" : "|-16-[content]-10-|"
            let content_constraint_V_Format = data?.role == Role.Sender ? "V:|-5-[content]-5-|" : "V:|-5-[content]-5-|"
            
            
            let header_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:header_constraint_H_Format, options: [], metrics: nil, views: vd)
            let header_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:header_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let bubble_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:bubble_constraint_H_Format, options: [], metrics: nil, views: vd)
            let bubble_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:bubble_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            let content_constraint_H = NSLayoutConstraint.constraints(withVisualFormat:content_constraint_H_Format, options: [], metrics: nil, views: vd)
            let content_constraint_V = NSLayoutConstraint.constraints(withVisualFormat:content_constraint_V_Format, options: [], metrics: nil, views: vd)
            
            self.contentView.addConstraints(header_constraint_H)
            self.contentView.addConstraints(header_constraint_V)
            self.contentView.addConstraints(bubble_constraint_H)
            self.contentView.addConstraints(bubble_constraint_V)
            self.contentView.addConstraints(content_constraint_H)
            self.contentView.addConstraints(content_constraint_V)
            
        }
    }
    //头像
    lazy var headerImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
        return v
    }()
    //内容
    lazy var contentLbl : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.FontStyleNomarl
        return v
    }()
    //气泡
    lazy var bubbleImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        followInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    
    func followInit(){
        self.selectionStyle = .none
    }
    
}



//额外功能 输入框

class ChatInputTool : UIView {


    var hasTxt : Bool? {
        didSet {
            senderTool.isEnabled = hasTxt ?? false
        }
    }

    var inputTool : UITextField = {
        let v = UITextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.borderStyle = .none
        v.font = UIFont.systemFont(ofSize: 15)
        v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        v.leftViewMode = .always
        v.returnKeyType = .send
        v.placeholder = "Message..."
        return v
    }()

    var senderTool : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 4
        v.layer.masksToBounds = true
        v.setTitle("Send", for: .normal)
        v.setTitleColor(UIColor.lightQueenColor(), for: .normal)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        v.isEnabled = true
        return v
    }()
    
    var imageTool : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 4
        v.layer.masksToBounds = true
        v.setImage(UIImage(named:"camera"), for: .normal)
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        followInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    var vd : [String : AnyObject] = [String : AnyObject]()
    func followInit(){
        self.addSubview(inputTool)
        self.addSubview(senderTool)
//        self.addSubview(imageTool)
        vd = ["inputTool" : inputTool , "senderTool" : senderTool]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-10-[inputTool]-10-[senderTool(60)]-10-|", options: [], metrics: nil, views: vd))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[inputTool]-|", options: [], metrics: nil, views: vd))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:|-[senderTool]-|", options: [], metrics: nil, views: vd))
//        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:|-[imageTool]-|", options: [], metrics: nil, views: vd))
        
//        inputTool.rac_textSignal().subscribeNext({ (next) in
//            if let text = next as? String{
//                self.hasTxt = text.characters.count > 0
//            }
//        })
        
    }
}



extension UITableView {
    // 输入文字自动滚动至底部
    func scrollToBottom (animated:Bool,handler : (()->())? = nil) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if rows > 0 && sections > 0 {
            let sections_rows = IndexPath(row: rows - 1, section: sections - 1)
            
            self.scrollToRow(at: sections_rows as IndexPath, at: .bottom, animated: animated)
            
            if let d = handler {
                d()
            }
        }
        
    }
    
}




