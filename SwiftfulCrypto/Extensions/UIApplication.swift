//
//  UIApplication.swift
//  Krypton
//
//  Created by Adarsh Shukla on 27/03/22.
//

import Foundation
import SwiftUI

// for dismissing keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
