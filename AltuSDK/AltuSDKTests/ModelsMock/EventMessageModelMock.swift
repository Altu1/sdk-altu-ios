//
//  EventMessageModelMock.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 01/05/22.
//

import Foundation

struct EventMessageModelMock {
    
    let connectedString = """
    {
        "event": "connected",
        "connection_id": "XXXX",
        "data": {
            "slug": "XXXX",
            "identifier": "XXXX",
            "assistant_id": "1",
            "widget_id": "1",
            "widget": {
                "id": "1",
                "messaging": "1",
                "typing": {
                    "type": "dynamic",
                    "value": 35
                },
                "config": {
                    "tag": {
                        "publish": {
                            "url": "https://prime.altubots.com/tag/staging/rethink/84db55734373c86e6f7c4312a13920c5/tag.js",
                            "status": "published"
                        },
                        "measurements": {
                            "widget": {
                                "width": {
                                    "unit": "PX",
                                    "value": "450"
                                },
                                "height": {
                                    "unit": "PX",
                                    "value": "600"
                                }
                            },
                            "spacing": {
                                "margin_right": {
                                    "unit": "PX",
                                    "value": "10"
                                },
                                "margin_bottom": {
                                    "unit": "PX",
                                    "value": "10"
                                }
                            }
                        },
                        "floating_button": {
                            "type": "default",
                            "default": {
                                "color": "#117eff"
                            }
                        }
                    },
                    "inactivity": "10"
                }
            },
            "url_params": {
                "channel": "mobile",
                "homol": "1",
                "identifier": "XXXX",
                "slug": "rethink",
                "source": "mobile",
                "source_id": "1",
                "widget_identifier": "XXX",
                "connection_id": "XXXX",
                "ip": "00.000.000.53",
                "extra_info": null
            },
            "livechat": false,
            "homol": true
        }
    }
    """
    
    let chatMessageString = """
    {
        "event": "chat_message",
        "connection_id": "XXX",
        "data": [
            {
                "text": "Olá, Seja Bem vindo!",
                "type": "text"
            },
            {
                "text": "Qual o modelo e o ano do seu veículo?",
                "type": "text"
            },
            {
                "type": "text_input"
            }
        ]
    }
    """
    
    let endChatString = """
    {
        "event": "end_chat",
        "connection_id": "RcVHDeZTGjQCJXA=",
        "data": {}
    }
    """
    
    let endLiveChatString = """
    {
        "event": "end_livechat",
        "connection_id": "RcVHDeZTGjQCJXA=",
        "data": {}
    }
    """
    
    let startLiveChatString = """
    {
        "event": "start_livechat",
        "connection_id": "RcVHDeZTGjQCJXA=",
        "data": {}
    }
    """
}
