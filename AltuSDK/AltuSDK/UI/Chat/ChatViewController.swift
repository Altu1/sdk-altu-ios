//
//  ChatViewController.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 29/03/22.
//

import Foundation
import UIKit

class ChatTableView: UITableView {}

class ChatViewController: UIViewController {
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var footerStackView: UIStackView!
    @IBOutlet weak var snackStackView: UIStackView!
    @IBOutlet weak var chatTableView: ChatTableView!
    @IBOutlet weak var footerStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var footerStackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var snackStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var viewLoading: UIView!
   
    
    // MARK: Variable
    var config: D1AltuSdkConfig?
    var viewModel: ChatViewModelType?
    var data: [String:String]? = nil
    var extraHash: String? = nil
    var sourceId: String? = nil
    var widgetIdentifier: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let config = config {
            viewModel = ChatFactory().makeChatViewModel(config: config)
        }
        
        if let data = data {
            viewModel?.setData(data: data)
        }
        
        if let sourceId = sourceId {
            viewModel?.setSourceId(sourceId: sourceId)
        }
        
        if let extraHash = extraHash {
            viewModel?.setExtraHash(extraHash: extraHash)
        }
        
        if let widgetIdentifier = widgetIdentifier {
            viewModel?.setWidgetIdentifier(widgetIdentifier: widgetIdentifier)
        }
        
        setupContentStackViewBind()
        setupFooterStackViewBind()
        setupSnackViewBind()
        setupAlertViewBind()
        
        fillComponents()
        
        viewModel?.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dissmissKeyboardAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShowNotification(notification: NSNotification) {
        let notification = notification.userInfo
        let keyboardFrame = notification?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardFrameSize = keyboardFrame.cgRectValue
        
        if footerStackViewBottom.constant == 0 {
            if UIDevice.current.hasTopNotch {
                footerStackViewBottom.constant -= keyboardFrameSize.height - 35
            } else {
                footerStackViewBottom.constant -= keyboardFrameSize.height
            }
        }
        self.viewModel?.reloadTableViewAndScrollToBottom()
    }

    @objc func keyboardWillHideNotification(notification: NSNotification) {
        let notification = notification.userInfo
        let keyboardFrame = notification?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardFrameSize = keyboardFrame.cgRectValue

        if footerStackViewBottom.constant != 0 {
            if UIDevice.current.hasTopNotch {
                footerStackViewBottom.constant += keyboardFrameSize.height - 35
            } else {
                footerStackViewBottom.constant += keyboardFrameSize.height
            }
        }
    }
}

//MARK: Components
extension ChatViewController {
    private func fillComponents() {
        loading.color = UIColor.black
        self.fillHeader()
        self.fillContent()
        self.fillSnack()
        self.fillFooter()
    }
    
    private func fillHeader() {
        guard let config = config else { return }
        
        let headerTitle = NSMutableAttributedString(string: config.titleChat, attributes: [NSAttributedString.Key.foregroundColor: config.backgroundColor ])
        
        let headerItem = ChatHeaderItem(title: headerTitle, backgroundColor: config.secundaryColor, imageLogo: config.bigAvatar)
        headerItem.buttonPressed = { [weak self] in
            guard let self = self else { return }
            self.closeModal()
        }
        
        self.headerStackView.fillStackView(withItems: [headerItem])
    }
    
    private func fillSnack() {
        guard let config = config else { return }
        
        let descriptionText = NSMutableAttributedString(string: "Você está conversando com um atendente humano", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white ])
        let actionText = NSMutableAttributedString(string: "[Sair]", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white ])
        
        let snackItem = SnackItem(descriptionText: descriptionText, actionText: actionText, backgroundColor: config.mainColor, descriptionTextColor: UIColor.white, actionTextColor: UIColor.white)
        snackItem.buttonPressed = { [weak self] in
            guard let self = self else { return }
            self.viewModel?.sendEndLiveChat()
        }
        
        self.snackStackView.fillStackView(withItems: [snackItem])
    }
    
    private func fillContent() {
        self.chatTableView?.rowHeight = UITableView.automaticDimension
        self.chatTableView?.dataSource = self.viewModel as? UITableViewDataSource
        self.chatTableView?.delegate = self.viewModel as? UITableViewDelegate
        
        let bundle = Bundle(for: ChatTableView.self)
        let simpleCellNib = UINib(nibName:SimpleTextViewCell.identifier, bundle: bundle)
        self.chatTableView?.register(simpleCellNib, forCellReuseIdentifier:SimpleTextViewCell.identifier)
        
        let balloonCellNib = UINib(nibName:BalloonMessageViewCell.identifier, bundle: bundle)
        self.chatTableView?.register(balloonCellNib, forCellReuseIdentifier: BalloonMessageViewCell.identifier)
        
        let separatorCellNib = UINib(nibName:SeparatorViewCell.identifier, bundle: bundle)
        self.chatTableView?.register(separatorCellNib, forCellReuseIdentifier: SeparatorViewCell.identifier)
    }
    
    private func fillFooter() {
        guard let config = config else { return }
        
        let inputMessage = InputMessageItem(backgroundColor: config.backgroundColor, buttonColor: config.secundaryColor)
        
        inputMessage.buttonSendMessagePressed = { [weak self] message in
            guard let self = self else { return }
            
            let messageFormated = message.trimmingCharacters(in: NSCharacterSet.whitespaces)
            let chatMessage = ChatMessageModel(type: .userMessage, message: messageFormated, date: Date(), showAvatar: false)
            self.viewModel?.sendMessage(chatMessage: chatMessage)
            self.dissmissKeyboardAction(self)
        }
        
        self.footerStackView.fillStackView(withItems: [inputMessage])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dissmissKeyboardAction))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification), name: UIWindow.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
}

// MARK: Binds
extension ChatViewController {
    private func setupSnackViewBind() {
        viewModel?.snackViewIsHidden = { [weak self] isHidden in
            self?.snackStackView.isHidden = isHidden
            DispatchQueue.main.async {
                if isHidden {
                    self?.snackStackViewHeight.constant = 0
                } else {
                    self?.snackStackViewHeight.constant = 40
                }
            }
        }
    }
    
    private func setupFooterStackViewBind() {
        viewModel?.footerStackViewIsHidden = { [weak self] isHidden in
            self?.footerStackView.isHidden = isHidden
            DispatchQueue.main.async {
                if isHidden {
                    self?.footerStackViewHeight.constant = 0
                } else {
                    self?.footerStackViewHeight.constant = 72
                }
            }
        }
    }
    
    private func setupContentStackViewBind() {
        viewModel?.reloadTableView = { [weak self] row in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.chatTableView.reloadData()
                
                if row > 0 {
                    let indexPath = IndexPath(row: row, section: 0)
                    self?.chatTableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
        
        viewModel?.hiddenLoading = { [weak self] isHidden in
            DispatchQueue.main.async {
                self?.loading.isHidden = isHidden
                self?.viewLoading.isHidden = isHidden
            }
        }
    }
    
    private func setupAlertViewBind() {
        viewModel?.showAlertView = { [weak self] message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    self?.closeModal()
                })
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
