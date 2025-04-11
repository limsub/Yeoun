//
//  CategoryVM.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import Foundation
import ReactorKit

class CategoryReactor: Reactor {
    
    let categoryID: String
    let repo = RealmRepository()
    
    init(categoryID: String) {
        self.categoryID = categoryID
    }
    
    enum Action {
        case loadData
        case updateTitle(title: String)
        case updateSubtitle(subtitle: String)
        case deleteData
    }
    
    enum Mutation {
        case setData(item: CategoryItem?)
        case pass
    }
    
    struct State {
        var categoryItem: CategoryItem?
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData:
            Logger.print("LoadData")
            if let item = repo.fetchCategory(categoryID) {
                
                // (v1.2) detailItemList를 최신 날짜 기준으로 정렬
                let newItem = CategoryItem(
                    id: item.id,
                    title: item.title,
                    subtitle: item.subtitle,
                    detailIdList: item.detailIdList.sorted {
                        $0.date > $1.date
                    }
                )
                
                return .just(.setData(item: newItem))
            }
            return .just(.pass)
            
            
        case .updateTitle(let title):
            Logger.print("Update title : \(title)")
            repo.updateCategoryTitle(categoryId: categoryID, newTitle: title)
            return .just(.pass)
            
        case .updateSubtitle(let subtitle):
            Logger.print("Update subtitle : \(subtitle)")
            repo.updateCategorySubtitle(categoryId: categoryID, newSubtitle: subtitle)
            return .just(.pass)
            
        case .deleteData:
            Logger.print("Delete Data")
            repo.deleteCategory(categoryId: categoryID)
            return .just(.pass)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setData(let item):
            newState.categoryItem = item
            
        case .pass:
            Logger.print("pass")
        }
        
        return newState
    }
}
