//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by user226607 on 9/2/22.
//

import SwiftUI



struct ContentView: View {
    
    let column: [GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible()),]
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoardDisabled = false
    @State private var alertItem:AlertItem?
   
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: column, spacing: 5) {
                    ForEach(0..<9) {i in
                        ZStack {
                            Circle()
                                .foregroundColor(.red).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15,
                                       height:geometry.size.width/3 - 15)
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width:40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves, forIndex: i) {return}
                            moves[i] = Move(player: .human, boardIndex: i)
                            isGameBoardDisabled = true
                            
                            //check for win or draw
                            
                            if checkWinCondition(for: .human, in: moves){
                                alertItem = AlertContext.humanWin
                                return
                            }
                            if checkForDraw(in: moves){
                                alertItem = AlertContext.draw
                                return
                            }
                            isGameBoardDisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameBoardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves){
                                    alertItem = AlertContext.ComputerWin
                                    return
                                }
                                if checkForDraw(in: moves){
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                        }
                    }
                }
                 Spacer()
            }
            .disabled(isGameBoardDisabled)
            .padding()
            .alert(item: $alertItem,content: { alertItem in
                Alert(title: alertItem.title,
                      message:alertItem.message,
                      dismissButton:.default(alertItem.buttonTitle, action: { resetGame()}) )
            })
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    //if  AI can win, then win
    //if AI cant win, then block
    //if AI cant block then take take niddle sqaure
    //if AI cant take middle sqaure, take random available square.
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        
        //if  AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8],[0,3,6],
                                          [1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let computerMoves = moves.compactMap { $0 }.filter {$0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first!}
            }
        }
        //if AI cant win, then block
        let humanMoves = moves.compactMap { $0 }.filter {$0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first!}
            }
        }
        
        
        //if AI cant block then take take middle sqaure
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        
        
        
        
        //if AI cant take middle sqaure, take random available square.
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
             movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    //checking for win position
    func checkWinCondition(for player: Player,in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8],[0,3,6],
                                          [1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap { $0 }.filter {$0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true}
        
        return false
    }
    //checking for draw conditions
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap {$0 }.count == 9
    }
    
    //reset game func
    func resetGame(){
    moves = Array(repeating: nil, count: 9)
    }
}

enum Player {
    case human, computer
}
//moves setup
struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
