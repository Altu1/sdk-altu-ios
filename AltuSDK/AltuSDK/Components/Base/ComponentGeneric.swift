//
//  ComponentGeneric.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 27/03/22.
//

import UIKit

open class ComponentGeneric<T: ComponentPresenterView>: ComponentPresenterModelImpl<T> {

    public override init(nibName: String) {
        super.init(nibName: nibName)
    }
}
