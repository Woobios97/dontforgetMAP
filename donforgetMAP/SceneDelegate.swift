//
//  SceneDelegate.swift
//  donforgetMAP
//
//  Created by 김우섭 on 2023/07/07.
//

import UIKit
import KakaoSDKAuth
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let locationManager = CLLocationManager()
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
           if let url = URLContexts.first?.url {
               if (AuthApi.isKakaoTalkLoginUrl(url)) {
                   _ = AuthController.handleOpenUrl(url: url)
               }
           }
       }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

extension SceneDelegate: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didEnterRegion region: CLRegion
    ) {
        if region is CLCircularRegion {
            handleEvent(for: region)
        }
    }
    
    func handleEvent(for region: CLRegion) {
        // 이전에 저장한 설정 값을 불러옵니다.
        var notiStatus: Bool?
        if UserDefaults.standard.object(forKey: "isNotiOn") == nil {
            notiStatus = true
        } else {
            notiStatus = UserDefaults.standard.bool(forKey: "isNotiOn")
        }
        
        if !(notiStatus ?? true) {
            return
        }
        
        let notificationContent = UNMutableNotificationContent()
        let todoItems = TodoManager.allTodoManager()

        let todo = todoItems.first(where: { $0.id == region.identifier })

        let notificationCenter = UNUserNotificationCenter.current()

        // 현재 날짜 가져오기
        let currentDate = Date()

        // 알림 설정 확인
        notificationCenter.getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                // Todo의 날짜를 가져옴 (예시: Date 형식으로 되어있다고 가정)
                if let todoDate = todo?.date {
                    // 현재 날짜와 Todo의 날짜를 비교 (년, 월, 일만 비교)
                    let calendar = Calendar.current
                    let dateComponents: Set<Calendar.Component> = [.year, .month, .day]
                    let currentDateComponents = calendar.dateComponents(dateComponents, from: currentDate)
                    let todoDateComponents = calendar.dateComponents(dateComponents, from: todoDate)

                    if currentDateComponents == todoDateComponents {
                        // 현재 날짜와 Todo의 날짜가 년, 월, 일이 모두 일치하는 경우
                        let content = UNMutableNotificationContent()
                        content.title = "까먹지Map"
                        content.body = todo?.todo ?? "투두를 확인해주세요!"

                        let uuidString = UUID().uuidString
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        let request = UNNotificationRequest(identifier: "Test-\(uuidString)", content: content, trigger: trigger)
                        notificationCenter.add(request, withCompletionHandler: { (error) in
                            if let error = error {
                                // 에러 처리
                                print("Error adding notification request: \(error)")
                            }
                        })
                    }
                }
            }
        }
    }

}
