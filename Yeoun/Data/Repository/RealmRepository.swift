//
//  RealmRepository.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import Foundation
import RealmSwift

class RealmRepository {
    
    let realm = try! Realm()
    
}

// MARK: - CREATE
extension RealmRepository {
    func addCategory(_ item: CategoryItem) {
        do {
            try realm.write {
                let dto = CategoryDBDTO(item)
                realm.add(dto)
                Logger.print("makeCategory Success")
                Logger.print("\(dto)")
            }
        } catch {
            Logger.print("makeCategory Error")
        }
    }
    
    func addDetail(categoryId: String, item: DetailItem) {
        guard let categoryDTO = realm.object(ofType: CategoryDBDTO.self, forPrimaryKey: categoryId) else {
            Logger.print("addDetail Error")
            return
        }
        
        do {
            try realm.write {
                let dto = DetailDBDTO(item)
                categoryDTO.detailList.append(dto)  // 이러면 아마 알아서 DetailDBDTO 에도 추가됨
                Logger.print("addDetail Success")
            }
        } catch {
            Logger.print("addDetail Error")
        }
    }
}


// MARK: - READ
extension RealmRepository {
    func fetchAllCategory() -> [CategoryItem] {
        return realm.objects(CategoryDBDTO.self).map { $0.toDomain() }.reversed()
    }
    
    func fetchCategory(_ categoryId: String) -> CategoryItem? {
        return realm.object(ofType: CategoryDBDTO.self , forPrimaryKey: categoryId)?.toDomain()
    }
    
    func fetchDetailItems(_ categoryId: String) -> [DetailItem] {
        guard let categoryDTO = realm.object(ofType: CategoryDBDTO.self, forPrimaryKey: categoryId) else {
            Logger.print("fetchDetailItems Error")
            return []
        }
        
        return categoryDTO.detailList.map { $0.toDomain() }
    }
    
    func fetchDetail(_ detailId: String) -> DetailItem? {
        return realm.object(ofType: DetailDBDTO.self , forPrimaryKey: detailId).map { $0.toDomain() }
    }
}



// MARK: - UPDATE
extension RealmRepository {
    func updateCategoryTitle(categoryId: String, newTitle: String) {
        guard let categoryDTO = realm.object(ofType: CategoryDBDTO.self, forPrimaryKey: categoryId) else {
            Logger.print("updateCategoryTitle Error")
            return
        }
        
        do {
            try realm.write {
                categoryDTO.title = newTitle
                Logger.print("updateCategoryTitle Success")
            }
        } catch {
            Logger.print("updateCategoryTitle Error")
        }
    }
    
    func updateCategorySubtitle(categoryId: String, newSubtitle: String) {
        guard let categoryDTO = realm.object(ofType: CategoryDBDTO.self, forPrimaryKey: categoryId) else {
            Logger.print("updateCategoryTitle Error")
            return
        }
        
        do {
            try realm.write {
                categoryDTO.subtitle = newSubtitle
                Logger.print("updateCategoryTitle Success")
            }
        } catch {
            Logger.print("updateCategoryTitle Error")
        }
    }
    
    func updateDetailContent(detailId: String, newContent: String) {
        guard let detailDTO = realm.object(ofType: DetailDBDTO.self, forPrimaryKey: detailId) else {
            Logger.print("updateDetailContent Error: Detail not found")
            return
        }
        
        do {
            try realm.write {
                detailDTO.content = newContent
                Logger.print("updateDetailContent Success")
            }
        } catch {
            Logger.print("updateDetailContent Error")
        }
    }
}


// MARK: - DELETE
extension RealmRepository {
    func deleteCategory(categoryId: String) {
        guard let categoryDTO = realm.object(ofType: CategoryDBDTO.self, forPrimaryKey: categoryId) else {
            Logger.print("deleteCategory Error: Category not found")
            return
        }
        
        do {
            try realm.write {
                realm.delete(categoryDTO) // 카테고리 삭제
                Logger.print("deleteCategory Success")
            }
        } catch {
            Logger.print("deleteCategory Error")
        }
    }
    
    func deleteDetail(detailId: String) {
        guard let detailDTO = realm.object(ofType: DetailDBDTO.self, forPrimaryKey: detailId) else {
            Logger.print("deleteDetail Error: Detail not found")
            return
        }
        
        do {
            try realm.write {
                realm.delete(detailDTO) // 디테일 삭제
                Logger.print("deleteDetail Success")
            }
        } catch {
            Logger.print("deleteDetail Error")
        }
    }
}
