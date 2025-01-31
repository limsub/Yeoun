//
//  HomeVM.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import Foundation
import ReactorKit

class HomeReactor: Reactor {
    
    // MARK: - Component
    let repo = RealmRepository()
    
    enum Action {
        case loadData
    }
    
    enum Mutation {
        case setData(items: [CategoryItem])
    }
    
    struct State {
        var categoryItemList: [CategoryItem] = []
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData:
            let itemList = repo.fetchAllCategory()
            return .just(.setData(items: itemList))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setData(let items):
            newState.categoryItemList = items
        }
        
        return newState
    }
}
