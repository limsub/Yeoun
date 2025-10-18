//
//  DetailVM.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import Foundation
import ReactorKit

class DetailReactor: Reactor {
    
    let detailID: String
    let repo = RealmRepository()
    
    init(detailID: String) {
        self.detailID = detailID
    }
    
    enum Action {
        case loadData
        case updateData(newContent: String)
        case deleteData
    }
    
    enum Mutation {
        case setData(item: DetailItem?)
        case pass
    }
    
    struct State {
        var detailItem: DetailItem?
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData:
            Logger.print("Load Data")
            let item = repo.fetchDetail(detailID)
            return .just(.setData(item: item))
            
        case .updateData(let newContent):
            Logger.print("Update Data : \(newContent)")
            repo.updateDetailContent(detailId: detailID, newContent: newContent)
            return .just(.pass)
            
        case .deleteData:
            Logger.print("Delete Data")
            repo.deleteDetail(detailId: detailID)
            return .just(.pass)
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setData(let item):
            newState.detailItem = item
            Logger.print("title : \(item?.title)")
            Logger.print("content : \(item?.content)")
            
        case .pass:
            Logger.print("pass")
        }
        
        return newState
    }
}
