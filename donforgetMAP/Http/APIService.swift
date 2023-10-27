//
//  Http.swift
//  donforgetMAP
//
//  Created by 진정수 on 2023/07/30.
//

import Foundation
import Moya

enum APIError: Error {
    case invalidResponse
    case decodingError
    case networkError
    case apiError(message: String)
}

protocol ResponseDataProtocol: Decodable {
    var status: String { get }
    var message: String { get }
}

struct ResponseData: ResponseDataProtocol {
    let status: String
    let message: String
}

class APIService {
    
    static let shared = APIService()
    private init() {}
    
    private let provider = MoyaProvider<API>()
 
    var authToken: String? = UserDefaults.standard.string(forKey: "JWT") {
        didSet {
            // 토큰이 설정되거나 변경되었을 때 추가적인 로직 수행
            if let newToken = authToken {
                // 새로운 토큰이 설정된 경우 UserDefaults에 저장
                UserDefaults.standard.set(newToken, forKey: "JWT")
                checkTokenExpiration(token: newToken) // 토큰 만료 여부 확인
            } else {
                // 토큰이 초기화되거나 없는 경우 UserDefaults에서 삭제
                UserDefaults.standard.removeObject(forKey: "JWT")
            }
        }
    }
    
    private func checkTokenExpiration(token: String) {
        // 토큰 디코딩 및 "exp" 클레임 확인하여 토큰 만료 여부 처리
        // 예시로 만료 시간이 지났다고 가정하고 토큰을 초기화
        if isTokenExpired(token) {
            authToken = nil
        }
    }
    
    private func isTokenExpired(_ token: String) -> Bool {
        // 토큰 디코딩 후 "exp" 클레임 확인하는 로직
        // 예시로 현재 시간을 기준으로 토큰 만료 시간이 지났다고 가정
        let currentTimestamp = Date().timeIntervalSince1970
        if let payload = decodeJWTPayload(from: token),
           let expTimestamp = payload["exp"] as? TimeInterval,
           expTimestamp <= currentTimestamp {
            return true
        }
        return false
    }
    
    private func decodeJWTPayload(from token: String) -> [String: Any]? {
        // JWT 토큰 디코딩 로직 (예시로 디코딩하지 않고 nil 반환)
        return nil
    }
    
    enum API {
        // API추가
        //MARK: 로그인 및 유저
        case login(email: String, password: String)
        case snsLogin(provider: String)
        case logout
        case userDelete
        
        //MARK: TODO
        case createTodo(todo: String, date: String)
        case getTodo(date: String)
        case updateTodo(todoId: String, todo: String)
        case deleteTodo(todoId: String)
        case updateTodoStatus(todoId: String, status: String)
        
        //MARK: Map
        case createTodoLocation(todoId: String, lat: String, lng: String)
        case getTodoLocation(todoId: String)
        case updateTodoLocation(todoId: String, lat: String, lng: String)
        case deleteTodoLocation(todoId: String)
    }
}

extension APIService.API: TargetType {
    var baseURL: URL {
        return URL(string: "https://dontforgetmap.shop")!
    }
    
    var path: String {
        switch self {
            // API 엔드포인트 지정
            
            //MARK: 로그인 및 유저
        case .login:
            return "/login"
        case .snsLogin(provider: let provider):
            print("/auth/\(provider)/login")
            return  "/auth/\(provider)/login"
        case .logout:
            return "/auth/logout"
        case .userDelete:
            return "/user/delete"
            
            //MARK: TODO
        case .createTodo(todo: _, date: _):
            return "/todo/create"
        case .getTodo(date: _):
            return "/todo"
        case .updateTodo(todoId: let todoId, todo: _):
            return "/todo/\(todoId)"
        case .deleteTodo(todoId: let todoId):
            return "/todo/\(todoId)/delete"
        case .updateTodoStatus(todoId: let todoId, status: _):
            return "/todo/\(todoId)/status "
            
            //MARK: MAP
        case .createTodoLocation(todoId: let todoId, lat: _, lng: _):
            return "/location/\(todoId)/create"
        case .getTodoLocation(todoId: let todoId):
            return "/location/\(todoId)"
        case .updateTodoLocation(todoId: let todoId, lat: _, lng: _):
            return "/location/\(todoId)/update"
        case .deleteTodoLocation(todoId: let todoId):
            return "/location/\(todoId)/delete"
        }
    }
    
    var method: Moya.Method {
        switch self {
            // API 통신 방법 지정
            
            //MARK: 로그인 및 유저
        case .login:
            return .post
        case .snsLogin:
            return .post
        case .logout:
            return .post
        case .userDelete:
            return .delete
            
            //MARK: TODO
        case .createTodo:
            return .post
        case .getTodo:
            return .post
        case .updateTodo:
            return .put
        case .deleteTodo:
            return .delete
        case .updateTodoStatus:
            return .put
            
            //MARK: MAP
        case .createTodoLocation:
            return .post
        case .getTodoLocation:
            return .post
        case .updateTodoLocation:
            return .put
        case .deleteTodoLocation:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
            // API 엔드포인트에 필요한 파라미터를 추가해줍니다.
            
            //MARK: 로그인 및 유저
        case let .login(email, password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .snsLogin(_):
            return .requestPlain
        case .logout:
            return .requestPlain
        case .userDelete:
            return .requestPlain
            
            //MARK: TODO
        case let .createTodo(todo, date):
            return .requestParameters(parameters: ["todo": todo, "date": date ], encoding: JSONEncoding.default)
        case let .getTodo(date):
            return .requestParameters(parameters: ["date": date], encoding: JSONEncoding.default)
        case let .updateTodo(todoId, todo):
            return .requestParameters(parameters: ["todoId": todoId, "todo" : todo ], encoding: JSONEncoding.default)
        case let .deleteTodo(todoId):
            return .requestParameters(parameters: ["todoId": todoId ], encoding: JSONEncoding.default)
        case let .updateTodoStatus(todoId, status):
            return .requestParameters(parameters: ["todoId": todoId, "status" : status ], encoding: JSONEncoding.default)
            
            //MARK: MAP
        case let .createTodoLocation(todoId, lat, lng):
            return .requestParameters(parameters: ["todoId": todoId, "lat": lat, "lng" : lng ], encoding: JSONEncoding.default)
        case let .getTodoLocation(todoId):
            return .requestParameters(parameters: ["todoId": todoId], encoding: JSONEncoding.default)
        case let .updateTodoLocation(todoId, lat, lng):
            return .requestParameters(parameters: ["todoId": todoId, "lat": lat, "lng" : lng], encoding: JSONEncoding.default)
        case let .deleteTodoLocation(todoId):
            return .requestParameters(parameters: ["todoId": todoId], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        // 헤더에 필요한 정보를 담아줍니다.
        var headers = ["Content-Type": "application/json"]
        if let token = APIService.shared.authToken {
            headers["Authorization"] = "\(token)" // 토큰을 헤더에 추가
        }
        print(headers)
        return headers
    }
}

extension APIService {
    func login(email: String, password: String, completion: @escaping (Result<String, APIError>) -> Void) {
        provider.request(.login(email: email, password: password)) { result in
            switch result {
            case let .success(response):
                do {
                    // JWT 토큰 파싱
                    let tokenResponse = try response.map([String: String].self)
                    if let token = tokenResponse["token"] {
                        APIService.shared.authToken = token
                        print(token)
                        completion(.success(token))
                    } else {
                        completion(.failure(.invalidResponse))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            case let .failure(error):
                completion(.failure(.apiError(message: error.localizedDescription)))
            }
        }
    }
    
    func snsLogin(snsProvider: String, completion: @escaping (Result<String, APIError>) -> Void) {
        provider.request(.snsLogin(provider: snsProvider)) { result in
            switch result {
            case let .success(response):
                do {
                    guard let headers = response.response?.allHeaderFields else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    
                    if let token = headers["Authorization"] as? String {
                        APIService.shared.authToken = "Bearer " + token
                        
                        completion(.success(token))
                    } else {
                        completion(.failure(.invalidResponse))
                    }
                    
                } catch {
                    print("this is response fail")
                    completion(.failure(.decodingError))
                }
            case let .failure(error):
                print("this is response fail2")
                completion(.failure(.apiError(message: error.localizedDescription)))
            }
        }
    }
    
    func logout(completion: @escaping (Result<String, APIError>) -> Void) {
        provider.request(.logout) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try response.map(ResponseData.self)
                    // status와 message 처리
                    print(data.status)
                    print(data.message)
                    _ = data.status
                    _ = data.message
                    
                    if response.statusCode == 200 || response.statusCode == 201 {
                        completion(.success(data.status))
                    } else {
                        completion(.failure(.invalidResponse))
                    }
                } catch {
                    print("this is response fail")
                    completion(.failure(.decodingError))
                }
            case let .failure(error):
                print("this is response fail2")
                completion(.failure(.apiError(message: error.localizedDescription)))
            }
        }
    }
    
    func userDelete(completion: @escaping (Result<String, APIError>) -> Void) {
        provider.request(.userDelete) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try response.map(ResponseData.self)
                    // status와 message 처리
                    print(data.status)
                    print(data.message)
                    _ = data.status
                    _ = data.message
                    
                    if response.statusCode == 200 || response.statusCode == 201 {
                        completion(.success(data.status))
                    } else {
                        completion(.failure(.invalidResponse))
                    }
                } catch {
                    print("this is response fail")
                    completion(.failure(.decodingError))
                }
            case let .failure(error):
                print("this is response fail2")
                completion(.failure(.apiError(message: error.localizedDescription)))
            }
        }
    }
    
}


