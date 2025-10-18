//
//  RealmDTO.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import Foundation
import RealmSwift

class CategoryDBDTO: Object {
    @Persisted(primaryKey: true) var id: String // 현재 시간을 id로 저장 (yyyyMMddHHmmss)
    @Persisted var title: String
    @Persisted var subtitle: String
    @Persisted var detailList: List<DetailDBDTO>
    
    convenience init(_ item: CategoryItem) {
        self.init()
        
        self.id = item.id
        self.title = item.title
        self.subtitle = item.subtitle 
        self.detailList = List<DetailDBDTO>()
    }
    
    func toDomain() -> CategoryItem {
        return .init(
            id: id ,
            title: title ,
            subtitle: subtitle,
            detailIdList: detailList.map { $0.toDomain() }
        )
    }
}

class DetailDBDTO: Object {
    @Persisted(primaryKey: true) var id: String // 현재 시간을 id로 저장 (yyyyMMddHHmm)
    @Persisted var title: String = "";  // MARK: - 2025-10-18. title 새로 추가
    @Persisted var content: String
    @Persisted var date: String     // "yyyy MM dd HH:mm"

    
    convenience init(_ item: DetailItem) {
        self.init()
        
        self.id = item.id
        self.title = item.title
        self.content = item.content
        self.date = item.date
    }
    
    func toDomain() -> DetailItem {
        return .init(
            id: id,
            title: title,
            content: content,
            date: date
        )
    }
}

struct CategoryItem: Equatable {
    let id: String
    let title: String
    let subtitle: String
    let detailIdList: [DetailItem]
}

struct DetailItem: Equatable {
    let id: String
    let title: String
    let content: String
    let date: String
}
