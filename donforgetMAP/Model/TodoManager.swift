//
//  Todo.swift
//  donforgetMAP
//
//  Created by 김우섭 on 2023/07/19.
//

import UIKit

class TodoManager {
    // TodoManager를 싱글톤으로 구현합니다.
    static let shared = TodoManager()
    
    // 마커를 터치한 할 일 아이템의 고유 ID를 저장하는 변수
    static var tappedTodoId: String = ""
    
    private init() {}
    
    // Todo 항목 구조체를 TodoManager 안에 중첩 타입으로 선언
    struct Todo: Codable {
        var id: String // 고유 식별자
        var todo: String // 할 일 내용
        var isDone: Bool // 완료 여부
        var date: Date // 날짜
        var lat: Double // 위도
        var lng: Double // 경도
        
        // 위치가 설정되어 있는지 확인하는 게터
        var isLocationSet: Bool {
            get { return !(Int(lat) == 0 && Int(lng) == 0)} }
        
        // 인코딩 시 사용할 키를 정의하는 열거형 CodingKeys를 구현합니다.
        private enum CodingKeys: String, CodingKey {
            case id
            case todo
            case isDone
            case date
            case lat
            case lng
        }
        
        // 새로운 Todo 인스턴스를 생성하기 위한 사용자 정의 이니셜라이저를 구현합니다.
        init(id: String, todo: String, isDone: Bool, date: Date, lat: Double, lng: Double) {
            self.id = id
            self.todo = todo
            self.isDone = isDone
            self.date = date
            self.lat = lat
            self.lng = lng
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            todo = try container.decode(String.self, forKey: .todo)
            isDone = try container.decode(Bool.self, forKey: .isDone)
            date = try container.decode(Date.self, forKey: .date)
            
            // 위치 정보를 디코딩할 때, 각각의 위도와 경도를 사용하여 NMGLatLng 객체를 생성합니다.
            lat = try container.decode(Double.self, forKey: .lat)
            lng = try container.decode(Double.self, forKey: .lng)
        }
        
        // Encodable 프로토콜의 encode(to:) 메서드를 구현합니다.
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(todo, forKey: .todo)
            try container.encode(isDone, forKey: .isDone)
            try container.encode(date, forKey: .date)
            
            // 위치 정보를 인코딩할 때, 위도와 경도를 추출하여 저장합니다.
            try container.encode(lat, forKey: .lat)
            try container.encode(lng, forKey: .lng)
        }
    }
    
    // 모든 Todo 항목을 저장할 배열을 선언합니다.
    private var todoItems: [Todo] = []
    
    // UserDefaults에 Todo 항목을 저장할 때 사용할 키를 정의합니다.
    private let todoKey = "TodoItems"
    
    // UserDefaults에서 Todo 데이터를 불러와서 todoItems 배열에 저장합니다.
    func loadTodoData() {
        if let data = UserDefaults.standard.data(forKey: todoKey) {
            do {
                todoItems = try JSONDecoder().decode([Todo].self, from: data)
            } catch {
                print("Todo 아이템 디코딩 에러: \(error)")
            }
        }
        print(todoItems)
    }
    
    // 현재 todoItems 배열의 데이터를 UserDefaults에 저장합니다.
    func saveTodoData() {
        do {
            let data = try JSONEncoder().encode(todoItems)
            UserDefaults.standard.set(data, forKey: todoKey)
        } catch {
            print("Todo 아이템 인코딩 에러: \(error)")
        }
        print(todoItems)
    }
    
    // 새로운 Todo 아이템을 추가합니다. 각 아이템은 고유한 식별자(ID)를 갖습니다.
    func addNewTodoItem(todo: String, isDone: Bool, date: Date, lat: Double, lng: Double) {
        let newTodoItem = TodoManager.Todo(id: UUID().uuidString, todo: todo, isDone: isDone, date: date, lat: lat, lng: lng)
        todoItems.append(newTodoItem)
        saveTodoData()
    }
    
    // 기존의 Todo 아이템을 업데이트합니다.
    func updateTodoItem(_ todoItem: Todo) {
        if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
            todoItems[index] = todoItem
            saveTodoData()
        }
        print(todoItems)
    }
    
    // 특정 식별자 (ID)에 해당하는 Todo 아이템 전체를 삭제합니다.
    func deleteTodoItem(todoItemID: String) {
        if let index = todoItems.firstIndex(where: { $0.id == todoItemID }) {
            todoItems.remove(at: index)
            saveTodoData()
        }
        print(todoItems)
    }
    
    // 마커를 터치한 Todo 아이템의 위도와 경도를 업데이트합니다.
    func position(tappedTodoId: String, lat: Double, lng: Double) {
        if let index = todoItems.firstIndex(where: { $0.id == tappedTodoId }) {
            todoItems[index].lat = lat
            todoItems[index].lng = lng
            saveTodoData()
        }
    }
    
    // 마커를 터치한 Todo 아이템의 위도와 경도를 문자열 형태로 반환합니다.
    func getPosition(tappedTodoId: String) -> String {
        if let index = todoItems.firstIndex(where: { $0.id == tappedTodoId }) {
            return String(format: "%f", todoItems[index].lat) + "/" + String(format: "%f", todoItems[index].lng)
        }
        
        return ""
    }
    
    // 특정 날짜의 Todo 아이템을 필터링하여 반환합니다.
    func todoItems(for date: Date) -> [Todo] {
        let dateString = dateToString(date: date)
        return todoItems.filter { dateToString(date: $0.date) == dateString }
    }
    
    // 날짜를 원하는 형식으로 변환하는 보조 메서드입니다.
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

extension TodoManager {
  public class func allTodoManager() -> [Todo] {
      
      if let data = UserDefaults.standard.data(forKey: "TodoItems") {
          do {
              let todoItems = try JSONDecoder().decode([Todo].self, from: data)
              
              return todoItems
          } catch {
              print("Todo 아이템 디코딩 에러: \(error)")
          }
      }
      return []
  }
}
