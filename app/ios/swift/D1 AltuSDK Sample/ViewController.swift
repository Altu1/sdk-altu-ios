//
//  ViewController.swift
//  D1 AltuSDK Sample
//
//  Created by Ricardo Caldeira on 24/03/22.
//

import UIKit
import AltuSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var sourceIdTextField: UITextField!
    @IBOutlet weak var slugTextField: UITextField!
    @IBOutlet weak var secretTextField: UITextField!
    @IBOutlet weak var widgetIdentifierTextField: UITextField!
    @IBOutlet weak var conversationHistoryPickerView: UIPickerView!
    @IBOutlet weak var environmentWebSocketPickerView: UIPickerView!
    @IBOutlet weak var webSocketCustomTextField: UITextField!
    @IBOutlet weak var webSocketCustomTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var webSocketViewHeight: NSLayoutConstraint!
    @IBOutlet weak var environmentAuthPickerView: UIPickerView!
    @IBOutlet weak var authCustomTextField: UITextField!
    @IBOutlet weak var authCustomTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var authViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chatButton: UIButton!
    
    var conversationHistory: ConversationHistory = .ALWAYS
    var environmentWebSocket: Environment = .DEV
    var environmentAuth: Environment = .DEV
    private var conversationHistorys = ["ALWAYS", "ONGOING"]
    private var environments = ["DEV", "STG", "PRD", "CUSTOM"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatButton.titleLabel?.text = ""
        
        self.dismissKeyboard()
        self.environmentWebSocketPickerView.dataSource = self
        self.environmentWebSocketPickerView.delegate = self
        self.conversationHistoryPickerView.dataSource = self
        self.conversationHistoryPickerView.delegate = self
        self.environmentAuthPickerView.dataSource = self
        self.environmentAuthPickerView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadConversation()
        loadEnvironmentWebSocket()
        loadEnvironmentAuth()
        setupLayout()
    }
    
    private func setupLayout() {
        let blackColor: UIColor = UIColor.black
        
        slugTextField.layer.borderColor = blackColor.cgColor
        slugTextField.layer.borderWidth = 1
        slugTextField.layer.cornerRadius = 6
        
        sourceIdTextField.layer.borderColor = blackColor.cgColor
        sourceIdTextField.layer.borderWidth = 1
        sourceIdTextField.layer.cornerRadius = 6
        
        secretTextField.layer.borderColor = blackColor.cgColor
        secretTextField.layer.borderWidth = 1
        secretTextField.layer.cornerRadius = 6
        
        widgetIdentifierTextField.layer.borderColor = blackColor.cgColor
        widgetIdentifierTextField.layer.borderWidth = 1
        widgetIdentifierTextField.layer.cornerRadius = 6
        
        webSocketCustomTextField.layer.borderColor = blackColor.cgColor
        webSocketCustomTextField.layer.borderWidth = 1
        webSocketCustomTextField.layer.cornerRadius = 6
        
        authCustomTextField.layer.borderColor = blackColor.cgColor
        authCustomTextField.layer.borderWidth = 1
        authCustomTextField.layer.cornerRadius = 6
    }
    
    @IBAction func buttonTouchUpInside(_ sender: Any) {
        openChat(widgetIdentifier: widgetIdentifierTextField.text ?? "", sourceId: sourceIdTextField.text ?? "")
    }
    
    func openChat(widgetIdentifier: String, sourceId: String) {
        //instanciar o arquivo de configuração do SDK
        let config = D1AltuSdkConfig()
        
        //Titulo do ChatBot
        config.titleChat = "D1 Jornadas Digitais"
        
        //Cor principal
        config.mainColor = UIColor(hexString: "#00284C")
        
        //Cor Secundaria
        config.secundaryColor = UIColor(hexString: "#098CFE")
        
        //Cor principal do texto
        config.mainTextColor = UIColor(hexString: "#1D1D1D")
        
        //Cor secundaria do texto
        config.secundaryTextColor = UIColor(hexString: "#B1B1B1")
        
        //Cor do background
        config.backgroundColor = UIColor(hexString: "#F5F5F5")
        
        //Configuração da imagem do avatar menor, ideal 32x32
        config.smallAvatar = #imageLiteral(resourceName: "smallAvatar")
        
        //Configuração da imagem do avatar maior, ideal 40x40
        config.bigAvatar = #imageLiteral(resourceName: "bigAvatar")
        
        ///Configurando qual ambiente o WebSocket do SDK deve usar, o ambiente default dentro do SDK é DEV, temos também o STG e PRD
        config.webSocketEnvironment = getEnvironmentWebSocket()
        
        //Configurando qual ambiente o SDK deve usar, o ambiente default dentro do SDK é DEV, temos também o STG e PRD
        config.environment = getEnvironment()
        
        //TODO: FALTAR EXPLICAR O PORQUE? de todos esses parametros no README e aqui também? ABAIXO
        config.slug = slugTextField.text ?? ""
        config.secret = secretTextField.text ?? ""
        
        //DeviceToken para integração do chat com o push
        config.deviceToken = UserDefaults.standard.data(forKey: "deviceToken") ?? Data()
        
        //Configurando o histórico de conversas
        //Se ConversationHistory for ONGOING então vamos manter o histórico apenas das conversas em andamento.
        //Se ConversationHistory for ALWAYS então vamos manter o histórico das mensagens até o limite das 100 últimas.
        config.conversationHistory = getConversationHistory()
        
        ///Configuração inicial D1 Altu SDK
        D1AltuSdk.sharedInstance.setup(config: config)
        
        let data: [String:String] = ["cpf":"00000000000",
                                     "rg": "00000000",
                                     "celular": "999999999"]
        let extraHash: String =  "919e7a508ac036e138dd53205ca35c50dcb87530e9ce6b1af00e424a27094b73f344544e11b44a00f8fdd11b19cf688d"
        
        ///O openChat vai abrir o chat e cuidar de TODA a interação com o usuario
        ///Passando a viewController atual
        ///O parametro widgetIdentifier que define o canal de atendimento
        ///O parametro sourceID ?????????
        ///O parametro data pode (opicional) ser passando um dicionario com informações adicionais.
        ///O parametro extraHash pode (opicional) ser enviado dados criptografados.
        D1AltuSdk.sharedInstance.openChat(viewController: self,
                                          widgetIdentifier: widgetIdentifier,
                                          sourceId: sourceId,
                                          data: data,
                                          extraHash: extraHash)
    }
}

extension UIViewController {
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}

//MARK: Picker Views
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == conversationHistoryPickerView {
            return conversationHistorys.count
        } else if pickerView == environmentWebSocketPickerView || pickerView == environmentAuthPickerView {
            return environments.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == conversationHistoryPickerView {
            return NSAttributedString(string: conversationHistorys[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        } else if pickerView == environmentWebSocketPickerView {
            if self.environmentWebSocketPickerView.selectedRow(inComponent: 0) == 3 {
                webSocketCustomTextFieldHeight.constant = 34
                webSocketCustomTextField.isHidden = false
                webSocketViewHeight.constant = 139
            } else {
                webSocketCustomTextFieldHeight.constant = 0
                webSocketCustomTextField.isHidden = true
                webSocketViewHeight.constant = 105
            }
            return NSAttributedString(string: environments[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        } else if pickerView == environmentAuthPickerView {
            if self.environmentAuthPickerView.selectedRow(inComponent: 0) == 3 {
                authCustomTextFieldHeight.constant = 34
                authCustomTextField.isHidden = false
                authViewHeight.constant = 139
            } else {
                authCustomTextFieldHeight.constant = 0
                authCustomTextField.isHidden = true
                authViewHeight.constant = 105
            }
            return NSAttributedString(string: environments[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
        return NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    fileprivate func loadConversation() {
        switch self.conversationHistory {
        case .ALWAYS:
            self.conversationHistoryPickerView.selectRow(0, inComponent: 0, animated: true)
            self.conversationHistory = .ALWAYS
            break
        case .ONGOING:
            self.conversationHistoryPickerView.selectRow(1, inComponent: 0, animated: true)
            self.conversationHistory = .ONGOING
            break
        }
    }
    
    fileprivate func loadEnvironmentWebSocket() {
        switch self.environmentWebSocket {
        case .DEV:
            self.environmentWebSocketPickerView.selectRow(0, inComponent: 0, animated: true)
            break
        case .STG:
            self.environmentWebSocketPickerView.selectRow(1, inComponent: 0, animated: true)
            break
        case .PRD:
            self.environmentWebSocketPickerView.selectRow(2, inComponent: 0, animated: true)
            break
        case .CUSTOM(_):
            self.environmentWebSocketPickerView.selectRow(3, inComponent: 0, animated: true)
            break
        }
    }
    
    fileprivate func loadEnvironmentAuth() {
        switch self.environmentAuth {
        case .DEV:
            self.environmentAuthPickerView.selectRow(0, inComponent: 0, animated: true)
            break
        case .STG:
            self.environmentAuthPickerView.selectRow(1, inComponent: 0, animated: true)
            break
        case .PRD:
            self.environmentAuthPickerView.selectRow(2, inComponent: 0, animated: true)
            break
        case .CUSTOM(_):
            self.environmentAuthPickerView.selectRow(3, inComponent: 0, animated: true)
            break
        }
    }
    
    private func getConversationHistory() -> ConversationHistory {
        let value: Int = self.conversationHistoryPickerView.selectedRow(inComponent: 0)
        switch value {
        case 0: return .ALWAYS
        case 1: return .ONGOING
        default:
            return .ALWAYS
        }
    }
    
    private func getEnvironmentWebSocket() -> Environment {
        let value: Int = self.environmentWebSocketPickerView.selectedRow(inComponent: 0)
        switch value {
        case 0: return .DEV
        case 1: return .STG
        case 2: return .PRD
        case 3: return .CUSTOM(environmentUrl: webSocketCustomTextField.text ?? "")
        default:
            return .DEV
        }
    }
    
    private func getEnvironment() -> Environment {
        let value: Int = self.environmentAuthPickerView.selectedRow(inComponent: 0)
        switch value {
        case 0: return .DEV
        case 1: return .STG
        case 2: return .PRD
        case 3: return .CUSTOM(environmentUrl: authCustomTextField.text ?? "")
        default:
            return .DEV
        }
    }
}
