//
//  SelectFontVM.swift
//  Yeoun
//
//  Created by 임승섭 on 1/26/25.
//

import Foundation
import ReactorKit

class SelectFontReactor: Reactor {
    enum Action {
        case selectFont(Int)
        case saveFontToUD
    }
    
    enum Mutation {
        case setSelectedFont(Int)
        case pass
    }
    
    struct State {
        var currentSelectedFont: Int = YeounFont.current.index
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectFont(let row):
            return .just(.setSelectedFont(row))
            
        case .saveFontToUD:
            let curFont = YeounFont.font(at: currentState.currentSelectedFont)
            YeounFont.set(curFont)
            return .just(.pass)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSelectedFont(let row):
            newState.currentSelectedFont = row
            
        case .pass:
            Logger.print("pass")
        }
        
        return newState
    }
}
