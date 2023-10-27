
# 까먹지MAP 📌 🗺️ 📋 _ 단 하나뿐인 위치기반 투두 서비스

<img width="859" alt="스크린샷 2023-10-25 오후 7 47 17" src="https://github.com/Woobios97/dontforgetMAP/assets/138302237/389977aa-f798-4811-bef5-0a0964f881c3">

<br/>

## 프로젝트 소개 🎙️

> 숨가쁘게 지나가는 하루 속🚶 , 퇴근길 🚇 , 혹은 출근길 🚉 등등 각자의 목표로 하는 거리 🛣️ 의 곳곳에 할 일을 상기시켜주기를 원하는 이들을 위해 개발 ⌨️
> 

‘아! 맞다, 0 0 샀어야 했는데..😯’ , ‘아! 맞다, 0 0 해오기로 했어야 했는데..😧’, ‘아! 맞다, 0 0 가지고 왔어야 했는데..🫨’ 등등 우린 너무 빠르게 💨 지나가는 하루 속에서 꼭 놓치는 일들이 있지는 않나요? 🤦🏻‍♂️ 이를 위해 **개발한 까먹지MAP, 당신의 일상 속 모든 거리에서 🚏 , 당신의 발걸음마다 👣, 놓치지 않게 도와드리겠습니다. 🧑🏻‍💻**

| Login 🚪 | Calendar_TodoList ✅ |
| ------------ | ------------- |
| ![Login](https://github.com/Woobios97/dontforgetMAP/assets/138302237/b41454f0-6a66-42cf-89ab-ed045c0a3a52) | ![Calendar_TodoList](https://github.com/Woobios97/dontforgetMAP/assets/138302237/4f0ed7fa-8e02-45d5-b164-92df01d8bb0f)  |

| Calendar_UI 🎨 | Setting ⚙️ |
| ------------ | ------------- |
| ![Calendar_UI](https://github.com/Woobios97/dontforgetMAP/assets/138302237/128fb2f9-50b3-4b71-b96a-3a6ce0e07419) | ![Setting](https://github.com/Woobios97/dontforgetMAP/assets/138302237/64568c5a-a63a-4e6a-b066-f11cff5e249b)  |

### Map 🗺️
![RPReplay_Final1698402285](https://github.com/Woobios97/dontforgetMAP/assets/138302237/3c1bc4da-253a-42da-8ee6-43cd1f8690a9)



<br/>

## 아키텍처 및 서비스플로우 🏗️

![Blank diagram (6) (1)](https://github.com/Woobios97/dontforgetMAP/assets/138302237/7fe4c5b0-b6e0-490e-a2c4-03bcccdc9a70)

<br/>

## Foldering 🗄️
```bash
─── DontforgetMAP
│ ├── Appdelegate
│ ├── SceneDelegate
│ │ ├── Model
│ │ │ ├── TodoManager
│ │ ├── Views
│ │ │ ├── Main.storyboard
│ │ │ ├── Popup.storyboard
│ │ │ ├── Todo
│ │ │ │ │ ├── TodoListCell
│ │ ├── Contollers
│ │ │ ├── OnboardingViewController
│ │ │ ├── CalendarViewController
│ │ │ ├── LoginSheetController
│ │ │ ├── SettingViewController
│ │ │ ├── AccountManagerController
│ │ │ ├── MapViewController
│ │ ├── Http
│ │ │ ├── APIService
│ │ ├── Utiles
│ │ │ ├── Popup
│ │ │ │ │ ├── AlertViewController
│ │ │ ├── Extension+color
│ │ │ │ │ ├── Extension+UIColor
│ │ │ ├── Font
│ │ │ │ │ ├── NanumSquareR.otf
│ │ │ │ │ ├──  Kyobo Handwriting 2019.otf
└────── DontforgetMAP
```

<br/>

## 프레임워크 & 디자인패턴 & 기술 스택 👨🏻‍💻
- **UIKit**
- **MVC**
- **GeoFencing**
    - **CoreLocation**
    - **UserNotifications**
    - **NMapsMap**
- **FSCalendar**
- **UserDefaults**
- **카카오, 구글, 애플로그인**
    - **JWT**
    - **KakaoSDK**
    - **GoogleSignIn**
    - **AuthenticationServices**
- **Moya**
- **ETC**
    - **Figma - App Design**
    - **Notion - Team Communication**
    - **discord - Team Communication**

<br/>

## 왜 이런 기술을 썼나요? 👀

- **MVC**

    - 계기
        - MVC패턴은 Model+View+Controller로 이루어진 디자인패턴으로 iOS개발자라면 모를 수 없는 디자인 패턴입니다. 앱개발의 전체적인 사이클을 처음으로 이루어지는 것이기 때문에 Apple에서 UIKit를 개발하기 위해 권장했던 MVC패턴을 사용했습니다.
  
    - 이유
        - 사실, **MVC패턴은 Apple이 제시하기 전에도, 있었던 디자인패턴개념입니다**. 전통적인 MVC구조는 Model, View, Controller가 밀접하게 연관이 되어있어 서로가 독립성이 없기도 했고 재사용성이 현저하게 낮아짐에 따라, 전통적인 MVC구조는 iOS개발에 적합하지않습니다. 이에 Apple은 CocoaMVC구조를 제시했고, Controller는 UIViewContoller가 그 역할을 합니다. **추후에 여러가지 디자인패턴을 적용하기 위해서는 가장 기본적인 MVC패턴을 알고 이를 왜 적용하는 지를 파악해야했기 때문에, MVC패턴을 사용했습니다.**
        
- **GeoFencing_CoreLocation, UserNotifications, NMapsMap**
    - 계기
        - **위치 기반의 Todo서비스로서, 해당 투두의 위치를 설정해주면, 그 근방으로 갔을 때 알림이 뜰 수 있는 기능**이 필요했습니다.
  
    - 이유
  
        - 이와 관련된 기능을 구현하기 위해서 앱스토어의 43위인 즉, **우리나라에서 가장 많이 쓰이는 네이버Map 외부라이브러리인 `NMapsMap`**를 이용하였습니다. 또한 앱**이 꺼진 상태에서의 `GeoFencing`이 필요했기 때문에 `SceneDelegate`를 확장해 `notificationCenter.getNotificationSettings` 를 통해 사용자가 앱이 꺼진 상태에서도 알림이 올 수 있게 설정**했습니다.
        
- **FSCalendar**

    - 계기
        - 달력기능을 구현하기 위해서 우선적으로 본 것은 역시, **`UICalendarView`** 였습니다. 그러나, 디자인 혹은 기획에 맞는 달력을 구현하기 위해서는 외부라이브러리에 필요성을 느꼈습니다.
  
    - 이유
        - FSCalendar는 iOS 9.0 이상부터 Ojective-C와 Swift 모두 사용할 수 있는 매우 호환적이고 안정적인 라이브러리입니다. 물론, 또 다른 라이브러리로, CVCalendar 혹은 JTAppleCalendar가 있습니다. 그럼에도 **FSCalendar**는 간단하고 직관적인 API를 제공하고, **다양한 테마와 스타일 옵션을 제공하여 기획하고자하는 앱디자인에 맞춰 달력을 개발할 수 있었기 때문에, 선택했습니다.**
        
- **UserDefaults**
    - 계기
        - 내부저장데이터를 어떤 것을 사용해야할까? 라는 고민이 많았습니다. 까먹지Map에서는 데이터가 사실 많지는 않았고, 간단했기 때문에, CoreData와 Keychain 등에 필요성을 못느꼈고, 무엇보다 정해진 기간 내에 이에 대한 학습곡선을 생각한다면 구현이 어렵다고 생각했습니다.
  
    - 이유
        - id(식별자), todo(할 일 내용), isDone(완료 여부), date(날짜), lat(위도), lng(경도) 등 비교적 간단하고 작은 양이라고 생각해 **UserDefaults**를 선택했습니다. 또한 내부저장데이터에 대한 학습이 필요했던 상황이라, **UserDefaults**를 사용해보면서 ‘내부저장이 이렇게 되는 구나’라는 큰 그림을 그릴 수 있게 되었습니다.
        
- **카카오, 구글, 애플로그인_JWT_KakaoSDK, GoogleSignIn, AuthenticationServices**
    - 계기
        - **개발 프로덕션모드에서 더 많은 유저를 앱에 유입시키기위해서는 꼭 필요한 기능이라고 작업이라고 생각했습니다.** 또한 한국 소비자연맹에 따르면 국내에 소셜로그인 시 사용하는 소셜미디어는 카카오, 구글, 애플 순으로 UI를 구성했습니다.
  
    - 이유
        - **사용자 경험 최적화**
            - 위와 같은 계기는 무엇보다 별도의 회원가입 과정없이 소셜 계정을 통해 로그인할 수 있습니다. 이는 사용자 경험을 크게 향상시킬 것이라 생각했습니다.
        - **서버 리소스 최적화**
            - 백엔드개발자분께서도 별도의 인증절차 없이 해당 토큰만을 검증하면 되므로, 인증절차에서의 서버 부하가 줄어들 것이라 했습니다.
        - **보안 강화**
            - 무엇보다 보안에 있어서 소셜플랫폼들을 통해서 인증절차를 거치는 것이기 때문에, 높은 수준의 보안을 유지할 수 있을 것이라 생각했습니다.
            
- **Moya**
    - 계기
        - **개발 프로덕션모드에서 더 많은 유저를 앱에 유입시키기위해서는 꼭 필요한 기능이라고 작업이라고 생각했습니다.** 또한 한국 소비자연맹에 따르면 국내에 소셜로그인 시 사용하는 소셜미디어는 카카오, 구글, 애플 순으로 UI를 구성했습니다.
  
    - 이유
        - **코드의 가독성 향상**
            - 무엇보다 Moya를 사용하면, 각 API 요청의 목적과 세부 사항을 명확하게 파악할 수 있었습니다. 이로 인해 코드의 가독성이 향상되었습니다.
        - **코드의 중복성 감소**
            - Moya는 Alamofire 위에 구축된 라이브러리로, Alamofire의 기능을 활용하면서도 반복되는 코드를 줄일 수 있습니다. 특히, 공통적인 헤더나 파라미터 설정, 에러 처리 등을 한 곳에서 관리할 수 있게 해준다는 점이 이번에 API통신을 구현하면서 간편하고 편리했습니다.

<br/>

## 고민/ 문제와 해결 과정 👨🏻‍⚕️

- UI 이슈
    - 고민/ 문제
        - FSCalendar 구현
            - 외부라이브러리를 쓴다는 것은 어떠한 기능을 구현하는데는 편하지만, 이를 커스텀하고자 할 때, 라이브러리의 문서를 잘 읽어보고 이를 잘 읽고 응용해야한다고 생각합니다. 저 역시, Figma에 따른 앱의 캘린더 디자인에 맞춰 FSCalendar의 헤더 혹은 폰트, 주말텍스트색상 등 FSCalenadar의 문서를 응용해야만 했습니다.
    - 해결
        - 문서화 자료 활용
            - FSCalendar의 공식 문서와 GitHub 저장소를 철저히 분석하였습니다. 이를 통해 라이브러리의 기본 기능뿐만 아니라 커스텀 가능한 부분들에 대한 정보를 얻을 수 있었습니다.
        - 커뮤니티 활용
            - StackOverflow와 같은 개발자 커뮤니티에서 FSCalendar에 관한 질문과 답변을 찾아보았습니다. 다른 개발자들이 겪었던 문제와 그에 대한 해결책을 통해, 제가 겪고 있는 문제에 대한 해결 방법을 찾을 수 있었습니다.
        - 실험적 접근
            - 문서에 명시되지 않은 커스텀 기능이 필요할 때, 직접 코드를 수정하거나 추가하여 원하는 결과를 얻을 수 있었습니다. 이 과정에서는 여러 시도와 오류를 겪었지만, 결국 원하는 디자인과 기능을 구현할 수 있었습니다.
        
        결과적으로, **외부 라이브러리를 커스텀하는 과정은 쉽지 않았지만, 다양한 자료와 커뮤니티를 활용하며 문제를 해결할 수 있었습니다. 이 경험을 통해 라이브러리를 그대로 사용하는 것이 아니라, 필요에 따라 적절히 수정하고 활용하는 능력을 키울 수 있었습니다.**

<br/>

- Data 바인딩
    - 고민/ 문제
        - FSCalendar에서의 날짜에 맞는 TableViewCell의 Data가 일치해야하는 문제
            - FSCalendar에 날짜를 선택했을 때, 그 날짜에 맞는 데이터가 나와야하며, 사용자가 그 날짜에 plus버튼을 눌러서 테이블뷰셀을 하나 추가 시켜서 할일목록을 추가시킨다면, Data에는 그 할일목록을 추가시켜야합니다.
  
    - 해결
        - FSCalendar 날짜 선택 이벤트 처리
            - 선택된 날짜와 해당 날짜에 대한 할 일 목록을 업데이트 하도록 했습니다.
                
                ```swift
                extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
                ...
                    // 날짜가 선택되었을 때 호출되며, 선택된 날짜와 해당 날짜에 대한 할 일 항목 목록을 업데이트합니다.
                    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
                        selectedDate = date // 선택된 날짜 업데이트
                        headerLabel.text = headerDateFormatter.string(from: date) // 헤더 레이블 업데이트
                        updateSelectedTodoItemsAndReloadTableView()  // 선택된 할 일 항목 업데이트 및 테이블 뷰 리로드
                    }
                    
                }
                ```
                
            
        - 할 일 추가
            - 사용자가 plus버튼을 눌러 할 일을 추가할 때, 현재 선택된 날짜에 할 일을 추가하고 테이블뷰를업데이트했습니다.
                
                ```swift
                @objc func plusAddButtonTapped() {
                        if let selectedDate = selectedDate {
                            
                            // 빈 문자열로 "todo" 필드를 가지고 새로운 Todo 아이템을 추가하고 위치 정보를 함께 저장합니다.
                            todoManager.addNewTodoItem(todo: "", isDone: false, date: selectedDate, lat: 0.0, lng: 0.0)
                            
                            // 업데이트된 Todo 아이템들을 가져와서 테이블 뷰를 리로드합니다.
                            updateSelectedTodoItemsAndReloadTableView()
                            
                            // 이벤트 점들을 업데이트하기 위해 캘린더 뷰를 리로드합니다.
                            calendarView.reloadData()
                            
                            // selectedTodoItems의 인덱스를 가져옴.
                            let indexPath = IndexPath(row: selectedTodoItems.count - 1, section: 0)
                            if let cell = tableView.cellForRow(at: indexPath) as? ToDoListCell {
                                cell.textField.becomeFirstResponder() // 새로운 텍스트필드에 초점을 맞춤
                                cell.textField.isUserInteractionEnabled = true
                            }
                        }
                    }
                ```
                
<br/>
                
- GeoFencing 이슈
    - 고민/ 문제
        - 사용자가 맵에서 탭을 했을 때, 마커가 생성되고 그 마커의 위치는 사용자가 지도를 나가는 순간 model에 저장되어야했습니다.
  
    - 해결
        - 사용자가 닫기 버튼( **`closeButtonTapped`** 메서드)을 탭했을 때의 로직을 활용하여 다음과 같은 해결 방안을 적용하였습니다:
          
            1. 마커의 위치가 **`(0, 0)`** 이 아니며, 마커가 지도에 찍혔을 경우에만 위치 정보를 처리합니다.
               
            2. **`TodoManager.shared.position`** 메서드를 사용하여 마커의 현재 위치 ( **`marker.position.lat`** 와 **`marker.position.lng`** )를 모델에 저장합니다.
               
            3. 지오펜싱을 등록하기 위해 **`CLLocationCoordinate2D`** 객체를 생성하여 마커의 위도와 경도를 설정합니다.
               
            4. **`CLCircularRegion`** 객체를 사용하여 지오펜싱 영역을 설정하고, 해당 영역에 진입 및 퇴장 시 알림을 받도록 설정합니다.
               
            5. **`locationManager.startMonitoring(for: region)`** 을 호출하여 지오펜싱을 시작하고, 지도 뷰를 닫습니다.
                
        - 이러한 방식으로 사용자가 지도에서 탭하여 마커를 생성하고, 닫기 버튼을 탭했을 때 마커의 위치를 모델에 저장하면서 동시에 해당 위치에 지오펜싱을 등록하여 사용자의 위치에 따른 알림을 제공할 수 있게 되었습니다.
        
    - 고민/ 문제
        - 사용자가 지도에서 마커를 찍었을 때, 그 반경에 들어갔을 때 계속 알람이 오는 문제가 있었습니다.
    - 해결
        
        ```swift
        // 위치가 설정되어 있지 않은 할 일 항목을 선택한 경우, 함수를 종료합니다.
        if !(selectedTodoItems[indexPath.row].isLocationSet) {
            return
        }
        
        // 해당 할 일 항목이 완료된 경우
        if selectedTodoItems[indexPath.row].isDone {
            // 현재 모니터링 중인 모든 지오펜싱 영역을 검사합니다.
            for region in locationManager.monitoredRegions {
                // 해당 지오펜싱 영역이 원형이며, 해당 항목의 ID와 일치하는 경우
                guard
                    let circularRegion = region as? CLCircularRegion,
                    circularRegion.identifier == selectedTodoItems[indexPath.row].id
                else { continue } // 일치하지 않는 경우, 다음 지오펜싱 영역을 검사합니다.
                
                // 해당 지오펜싱 영역의 모니터링을 중지합니다.
                locationManager.stopMonitoring(for: circularRegion)
            }
        } else { // 해당 할 일 항목이 완료되지 않은 경우
            // 해당 항목의 위치를 가져옵니다.
            let location = CLLocationCoordinate2D(latitude: selectedTodoItems[indexPath.row].lat, longitude: selectedTodoItems[indexPath.row].lng)
            
            // 해당 위치를 중심으로 반경 300.0의 지오펜싱 영역을 생성합니다.
            let region = CLCircularRegion(center: location, radius: 300.0, identifier: TodoManager.tappedTodoId)
            
            // 해당 영역에 진입하거나 퇴장할 때 알림을 받도록 설정합니다.
            region.notifyOnEntry = true
            region.notifyOnExit = true
        
            // 해당 지오펜싱 영역을 모니터링 시작합니다.
            locationManager.startMonitoring(for: region)
        }
        ```
        
        1. **위치가 설정되어 있지 않으면 리턴** :
            - **`selectedTodoItems[indexPath.row].isLocationSet`** 를 통해 해당 항목에 위치가 설정되어 있는지 확인합니다. 위치가 설정되어 있지 않다면 함수는 아무 작업도 수행하지 않고 종료됩니다.
              
        2. **할 일이 완료된 경우 지오펜싱 제거** :
            - **`selectedTodoItems[indexPath.row].isDone`** 을 통해 해당 항목이 완료되었는지 확인합니다.
            - 완료된 경우, **`locationManager.monitoredRegions`** 를 통해 현재 모니터링 중인 모든 지오펜싱 영역을 검사합니다.
            - 해당 항목의 ID와 일치하는 지오펜싱 영역이 있다면, 그 영역의 모니터링을 중지합니다.
              
        3. **할 일이 완료되지 않은 경우 지오펜싱 등록** :
            - **`selectedTodoItems[indexPath.row].lat`** 와 **`selectedTodoItems[indexPath.row].lng`** 를 사용하여 해당 항목의 위치를 가져옵니다.
            - 해당 위치를 중심으로 반경 300.0의 지오펜싱 영역을 생성하고, 해당 영역에 진입하거나 퇴장할 때 알림을 받도록 설정합니다.
            - 이 지오펜싱 영역을 모니터링 시작합니다.

<br/>

## 앞으로의 계획 / 회고🧭

- ### **디자인패턴의 직관적인 이해** 🙋🏻‍♂️

  MVC (Model-View-Controller) 패턴은 애플리케이션의 구조를 명확하게 분리하여 개발을 진행할 수 있게 도와주는 디자인 패턴 중 하나입니다. Model은 데이터와 비즈니스 로직을, View는 사용자 인터페이스를, Controller는 사용자의 입력을 처리하고 Model과 View 사이의 중개자 역할을 합니다.
  
    **하지만, 프로젝트가 진행됨에 따라 Controller에 코드가 계속해서 추가되기 시작했습니다. 이로 인해 Controller는 점점 더 복잡해지고, 여러 기능들이 중첩되어 스파게티 코드가 되어버렸습니다. 코드의 가독성은 떨어지게 되었고, 유지 보수도 어려워졌습니다.**
  
    이러한 문제를 겪으면서, **단순히 코드를 작성하는 것뿐만 아니라, 어떻게 더 효율적이고 유지 보수하기 쉬운 구조로 코드를 설계할 것인지에 대한 중요성을 깨달았습니다.**
  
    또한 MVVM, VIPER 등등의 디자인 패턴은 이러한 문제를 해결하기 위한 방법 중 하나로, 애플리케이션의 구조를 체계적으로 설계할 수 있게 도와줍니다.
    **결국, 코드의 구조와 디자인 패턴의 선택은 애플리케이션의 품질과 유지 보수성에 큰 영향을 미친다는 것을 깨달았습니다.**
    
- ### **첫 앱 배포 → 커뮤니케이션의 중요성** 🙇🏻‍♂️
  
  앱 개발의 여정은 단순한 코드 작성에서 시작되지 않습니다. 그것은 팀원들과의 협업, 프로젝트 관리, 그리고 실제 사용자를 대상으로 한 배포까지의 전체 과정을 포함합니다. 
  이번 프로젝트에서 저는 그 여정의 중요한 부분들을 경험하게 되었습니다.
  
    저희 팀은 Notion을 활용하여 프로젝트 관리를 진행했습니다. PM은 체계적인 WBS를 통해 각 팀원의 업무를 명확하게 정리하고, 이슈 사항을 실시간으로 체크하며 중간 역할을 해주었습니다. 이러한 체계적인 관리 덕분에 프로젝트의 진행 상황을 명확하게 파악할 수 있었고, 각자의 역할에 집중하여 더 효율적으로 작업을 진행할 수 있었습니다.
  
    이전에는 강의를 통한 프로젝트만 경험했었습니다. 그러나 이번에는 실제 앱을 배포하는 과정을 통해 사용자의 입장에서 앱을 바라보게 되었습니다. 실제로 앱을 배포하면서, 이전에는 경험해보지 못했던 다양한 이슈에 부딪히게 되었습니다.
  
    **특히, iOS앱개발자로서, 백엔드 개발자와 디자이너와의 소통이 매우 중요함을 느꼈습니다.**
  
    백엔드 개발자와의 소통에 있어서는 데이터의 흐름 혹은 API 스펙에 대한 정확한 이해 없이는 원할한 앱개발이 불가능했을 것입니다.
    디자이너와의 소통에 있어서는 디자인가이드나 에셋을 받을 때, 그것이 바로 개발에 바로 적용될 수 있는 형태인지, 아니면 추가적인 수정이 필요한 지를 판단하고, 다지아너와 함께 최적의 해결 방안을 찾아야 했습니다. 또한 디자이의 의도를 정확하게 이해하고 이를 코드로 옮기는 과정에서도 디자이너와의 지속적인 소통이 필요했습니다.
  
    **결론적으로, 첫 앱배포를 통해 개발자로서의 성장뿐만 아니라, 협업의 중요성, 사용자 중심의 사고 방식, 그리고 실제 배포 과정에서의 다양한 이슈 해결 능력을 키울 수 있었습니다. 이 경험은 앞으로의 개발 여정에 있어 큰 자산이 될 것이라 확신합니다.**
    
- ### **사용자 의견 반영에 따른 추후 앱기능 계획** 🚏
  
  **실사용자들의 의견을 들어보면서,** 그 날짜별로 카테고리가 따로 있어서 분리했으면 좋겠다는 피드백을 받았습니다. 따라서 추후에 기능을 추가할 예정입니다.
