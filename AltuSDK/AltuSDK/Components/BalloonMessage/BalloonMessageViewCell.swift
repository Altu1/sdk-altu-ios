//
//  BalloonMessageViewCell.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 03/04/22.
//

import UIKit

public class BalloonMessageViewCell: UITableViewCell {
    
    @IBOutlet weak var balloonMessageBotView: UIView!
    @IBOutlet weak var avatarBotImage: UIImageView!
    @IBOutlet weak var avatarBotImageWidth: NSLayoutConstraint!
    @IBOutlet weak var hourBotLabel: UILabel!
    @IBOutlet weak var hourBotLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var balloonBotView: UIView!
    @IBOutlet weak var messageBotLabel: UILabel!
    @IBOutlet weak var leadingSpacingBalloonBotView: NSLayoutConstraint!
    
    @IBOutlet weak var balloonMessageUserView: UIView!
    @IBOutlet weak var hourUserLabel: UILabel!
    @IBOutlet weak var hourUserLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var balloonUserView: UIView!
    @IBOutlet weak var messageUserLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    var config: D1AltuSdkConfig?
    
    static var identifier: String {
        return "BalloonMessageViewCell"
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }

    func configure(chatMessage: ChatMessageModel, nextMessageType: MessageType?, config: D1AltuSdkConfig) {
        self.config = config
        switch chatMessage.type {
        case .botMessage:
            balloonMessageUserView.isHidden = true
            balloonMessageBotView.isHidden = false
            
            configureHour(chatMessage: chatMessage,
                          nextMessageType: nextMessageType,
                          hourLabel: hourBotLabel,
                          hourLabelHeight: hourBotLabelHeight)
            
            configureAvatar(chatMessage: chatMessage,
                            nextMessageType: nextMessageType,
                            config: config)
            
            balloonBotView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            balloonBotView.backgroundColor = config.backgroundColor
            
            messageBotLabel.attributedText = chatMessage.message.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Helvetica Neue", size: 14), csscolor: config.mainTextColor.toHexString(), lineheight: 14, csstextalign: "left")
            
        case .userMessage:
            balloonMessageUserView.isHidden = false
            balloonMessageBotView.isHidden = true
            
            configureHour(chatMessage: chatMessage,
                          nextMessageType: nextMessageType,
                          hourLabel: hourUserLabel,
                          hourLabelHeight: hourUserLabelHeight)
            
            balloonUserView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
            balloonUserView.backgroundColor = config.secundaryColor
            
            messageUserLabel.attributedText = chatMessage.message.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Helvetica Neue", size: 14), csscolor: UIColor.white.toHexString(), lineheight: 14, csstextalign: "left")
        default:
            break
        }
    }
    
    private func configureHour(chatMessage: ChatMessageModel, nextMessageType: MessageType?, hourLabel: UILabel, hourLabelHeight: NSLayoutConstraint) {
        if nextMessageType == chatMessage.type {
            hourLabel.isHidden = true
            hourLabelHeight.constant = 0
        } else {
            if let date = chatMessage.date, let color = config?.mainTextColor {
                hourLabel.isHidden = false
                hourLabelHeight.constant = 15
                dateFormatter.dateFormat = "HH:mm"
                hourLabel.text = "\(dateFormatter.string(from: date))"
                hourLabel.textColor = color
            } else {
                hourLabel.isHidden = true
                hourLabelHeight.constant = 0
            }
        }
    }
    
    private func configureAvatar(chatMessage: ChatMessageModel, nextMessageType: MessageType?, config: D1AltuSdkConfig) {
        if let image = config.smallAvatar {
            if nextMessageType == chatMessage.type {
                avatarBotImage.isHidden = true
            } else {
                avatarBotImage.isHidden = chatMessage.showAvatar == false
                avatarBotImage.image = image
            }
        } else {
            avatarBotImage.isHidden = true
            avatarBotImageWidth.constant = 0
            leadingSpacingBalloonBotView.constant = 0
        }
    }
}
