//
//  MakeCategoryVM.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import Foundation
import ReactorKit

class MakeCategoryReactor: Reactor {
    let repo = RealmRepository()
    
    enum Action {
        case saveNewCategory(item: CategoryItem)
    }
    
    enum Mutation {
        case pass
    }
    
    struct State {
        
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .saveNewCategory(let item):
            repo.addCategory(item)
            return .just(.pass)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .pass:
            Logger.print("pass")
        }
        
        return newState
    }
}
