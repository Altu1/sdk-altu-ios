# D1 Smartkio ALTU SDK

Esse repositório contêm a documentação do SDK além de cópais dos pacotes binários para iOS.

## Gui de Implemetação

Esse é o SDK para a funcionalidade de comunicação via ChatBot [D1 Smartkio](https://www.d1.cx).

O SDK foi desenvolvido em Swift e conta com suporte amigável a ObjC

## Como instalar

Para utilizar o SDK deve-se segir o passo-a-passo abaixo. Recomenda-se conferir se as etapas estão feitas, adicionar as configurações e inicialização do chat com TODOS os parametros corretos, consultar o item [Configuração Avançada](#configuração-avançada).


## 1º Passo - Requisitos

- Conta na D1
- Um dispositivo iOS 12+ (iPhone, iPod Touch) para testar.
- Um Mac com Xcode 12+.


## 2º Passo - Importe o SDK da D1 para o seu projeto Xcode.

- Opção 1: Swift Package Manager ???
- Opção 2: Carthage ???
- Opção 3: CocoaPods ???

Pode-se usar manualmente também, bastando baixar o diretório lib e adicionando ao seu projeto, ajustando os paths de headers de acordo


## 3º Passo - Adicione o código de configuração do D1AltuSDK

Navegue até o arquivo da viewController que sera responsavel de abrir o chat e adicione o código de configuração do D1PushSDK.

Certifique-se de importar o AltuSDK:

- **Swift:** 

Adicione o import
```swift
import AltuSDK
```

Setar os parametros necessários no D1AltuSdkConfig como no exemplo abaixo

- **Swift:** 

```swift

///criar o arquivo de configuração do SDK
let config = D1AltuSdkConfig()

///Titulo do ChatBot
config.titleChat = "D1 Jornadas Digitais"
        
///Cor principal
config.mainColor = UIColor(hexString: "#F18D1E")
        
///Cor Secundaria
config.secundaryColor = UIColor(hexString: "#000000")
        
///Cor principal do texto
config.mainTextColor = UIColor(hexString: "#1D1D1D")
        
///Cor secundaria do texto
config.secundaryTextColor = UIColor(hexString: "#A3A3A3")
        
///Cor do background
config.backgroundColor = UIColor(hexString: "#EDEDED")
        
///Configuração da imagem do avatar menor, ideal 32x32
config.smallAvatar = #imageLiteral(resourceName: "smallAvatar")
        
///Configuração da imagem do avatar maior, ideal 40x40
config.bigAvatar = #imageLiteral(resourceName: "bigAvatar")
        
///Configurando qual ambiente o  Web Socket do SDK deve usar, o ambiente default dentro do SDK é DEV, temos também o STG e PRD
config.webSocketEnvironment = .DEV
        
///Configurando qual ambiente o SDK deve usar, o ambiente default dentro do SDK é DEV, temos também o STG e PRD
config.environment = .DEV

///Identificação do Cliente
config.slug = "valor informado pela D1"

///Chave de acesso fornecida pelo canal App
config.secret = "valor informado pela D1"

//DeviceToken para integração do chat com o push
config.deviceToken = Data()

///Configurando o histórico de conversas
//Se ConversationHistory for ONGOING então vamos manter o histórico apenas das conversas em andamento.
//Se ConversationHistory for ALWAYS então vamos manter o histórico das mensagens até o limite das 100 últimas.
config.conversationHistory = .ALWAYS
        
///Configuração inicial D1 Altu SDK
D1AltuSdk.sharedInstance.setup(config: config)
```

- Na linha ```config.webSocketEnviromnent``` deve-se escolher o ambiente que o Web Socket irá usar, que pode ser DEV, STG, PRD ou CUSTOM (onde pode ser passado um enviromment desejado). Enquanto desenvolve recomenda-se usar DEV.

- Na linha ```config.enviromnent```deve-se escolher o ambiente de autenticação que o app irá usar, que pode ser DEV, STG, PRD ou CUSTOM (onde pode ser passado um enviromment desejado). Enquanto desenvolve recomenda-se usar DEV.


## 4º Passo - Adicione o código de inicialização do D1AltuSDK

Na viewController que sera responsavel de abrir o chat e adicione o código de inicialização do D1PushSDK.

- **Swift:** 

```swift
///O openChat vai abrir o chat e cuidar de TODA a interação com o usuario
///Passando a viewController atual
///O parametro widgetIdentifier - Identidicador único da integração widget
///O parametro sourceID - Identifica o ID da integração
///O parametro data pode (opicional) ser passando um dicionario com informações adicionais
///O parametro extraHash pode (opicional) ser enviado dados criptografados
D1AltuSdk.sharedInstance.openChat(viewController: UIViewController,
                                  widgetIdentifier: String,
                                  sourceId: String,
                                  data: [String:String]?,
                                  extraHash: String?)
```

## 5º Passo - Recebendo e identificando um pushNotification da plataforma AltuSDK

Quando o push for da AltuSDK vira dentro do userInfo (no metodo userNotificationCenter) da notificação o objeto "_d1_cid" e dentro dele dois outros parametros "sourceId" e "widgetIdentifier" que seram nescessarios para abrir o chat como pode ver no codigo de exmplo abaixo

```swift
func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
            
            if isD1PushChat(userInfo: response.notification.request.content.userInfo) {
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                      let rootViewController = appDelegate.window!.rootViewController else { return }
                
                if let cid = response.notification.request.content.userInfo["_d1_cid"] as? [AnyHashable : Any], let vc = rootViewController as?                      ViewController {
                    
                    let sourceID: String = cid["sourceId"] as? String ?? ""
                    let widgetIdentifier: String = cid["widgetIdentifier"] as? String ?? ""
                    
                    vc.openChat(widgetIdentifier: widgetIdentifier, sourceId: sourceID)
                }
                
                completionHandler()
            } else {
                completionHandler()
            }
}
```

## Configuração avançada

Segue um detalhameno dos objetos e métodos do SDK

### D1PushConfig
Classe responsável por definir as configurações usadas no SDK. Só pode haver uma configuração ativa por vez.

### Construtor
Cria um objeto de configuração, requerido o AppID. O appID é o identificador que a DirectOne informa e que representa o aplicativo junto a plataforma de jornada. Cada ambiente terá um AppID distinto.

```swift
let config = D1PushConfig()
```

### Titulo
Para configurar o Titulo que aparecerar to topo do ChatBot

```swift
config.titleChat = String
```

### Cores
Para configurar as cores do ChatBot

- Cor principal
```swift
config.mainColor = UIColor
```

- Cor Secundaria
```swift
config.secundaryColor = UIColor
```
        
- Cor principal do texto
```swift
config.mainTextColor = UIColor
```
        
- Cor secundaria do texto
```swift
config.secundaryTextColor = UIColor
```
        
- Cor do background
```swift
config.backgroundColor = UIColor
```

### Imagem do Avatar
Para configurar as imagens do Big Avatar (fica ao lado do Titulo do ChatBot) e Small Avatar (Fica ao lado do balloon de mensagem do bot)

- Configuração da imagem do avatar maior, ideal 40x40
```swift
config.bigAvatar = UIImage
```

- Configuração da imagem do avatar menor, ideal 32x32
```swift
config.smallAvatar = UIImage
```

### Configuração de Ambiente
Deve-se escolher o ambiente que o app irá usar, que pode ser DEV, STG, PRD ou CUSTOM (onde pode ser passado um enviromment desejado). Enquanto desenvolve recomenda-se usar DEV.

- Configurando qual ambiente o  Web Socket do SDK deve usar, o ambiente default dentro do SDK é DEV, temos também o STG e PRD
```swift
config.webSocketEnvironment = .DEV
```

- Configurando qual ambiente o SDK deve usar, o ambiente default dentro do SDK é DEV, temos também o STG e PRD
```swift
config.environment = .DEV
```

### PushToken (Notificação)
Configuração do PushToken para receber notificações da plataforma ALTU

O deviceToken deve ser resgatado no metodo didRegisterForRemoteNotificationsWithDeviceToken no appDelegate e passado no config de acordo com os codigos abaixo

```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenRecuperado = deviceToken
}
```

```swift
config.deviceToken = Data
```

### Identificação do Cliente
Paramentro que identifica o cliente D1

```swift
config.slug = String
```

### Chave de acesso
Chave de acesso fornecida pelo canal App

```swift
config.secret = String
```

### Histórico de conversas
Se ConversationHistory for ONGOING então vamos manter o histórico apenas das conversas em andamento.
Se ConversationHistory for ALWAYS então vamos manter o histórico das mensagens até o limite das 100 últimas.

- Configurando o histórico de conversas
```swift
config.conversationHistory = .ALWAYS
```

### Setup de configuração
Configuração inicial D1 Altu SDK, já com todos os parametros de configuração devidamente adicionados

```swift
D1AltuSdk.sharedInstance.setup(config: config)
```

### Open Chat
O openChat vai abrir o chat e cuidar de TODA a interação com o usuario.

- Passando a viewController atual
- O parametro widgetIdentifier - Identidicador único da integração widget
- O parametro sourceID  - Identifica o ID da integração
- O parametro data pode (opicional) ser passando um dicionario com informações adicionais
- O parametro extraHash pode (opicional) ser enviado dados criptografados

```swift
D1AltuSdk.sharedInstance.openChat(viewController: UIViewController,
                                  widgetIdentifier: String,
                                  sourceId: String,
                                  data: [String:String]?,
                                  extraHash: String?)
```
