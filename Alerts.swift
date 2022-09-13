//
//  Alerts.swift
//  Tic Tac Toe
//
//  Created by user226607 on 9/2/22.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
   static let humanWin  = AlertItem(title: Text("You Win"),
                            message: Text("Bravo Homie.You MesUp the AI.!!!"),
                            buttonTitle: Text("Hell YEssss"))
    
    static let ComputerWin  = AlertItem(title: Text("You Loss"),
                            message: Text("hahaha.The AI mess you up.!!!"),
                            buttonTitle: Text("Rematch"))
    
   static let draw  = AlertItem(title: Text("Draw"),
                            message: Text("ho-ho Tough Draw"),
                            buttonTitle: Text("Try Again"))}
