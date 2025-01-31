//
//  MakeDetailVM.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import Foundation
import ReactorKit

class MakeDetailReactor: Reactor {
    
    let categoryID: String
    let repo = RealmRepository()
    
    init(categoryID: String) {
        self.categoryID = categoryID
    }
    
    enum Action {
        case loadData
        case saveNewDetail(item: DetailItem)
    }
    
    enum Mutation {
        case setTitle(title: String)
        case pass
    }
    
    struct State {
        var categoryTitle: String = ""
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData:
            if let item = repo.fetchCategory(categoryID) {
                return .just(.setTitle(title: item.title))
            } else {
                return .just(.pass)
            }
            
        case .saveNewDetail(let item):
            repo.addDetail(categoryId: categoryID, item: item)
            return .just(.pass)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTitle(let title):
            newState.categoryTitle = title
        case .pass:
            Logger.print("pass")
        }
        
        return newState
    }
}
