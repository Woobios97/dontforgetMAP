//
//  MapViewController.swift
//  donforgetMAP
//
//  Created by 김우섭 on 2023/07/28.
//

import UIKit
import NMapsMap
import CoreLocation
import NotificationCenter

class MapViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewDelegate {
    
    // 지도 뷰를 닫고 마커 위치를 저장하는 닫기 버튼
    private let closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    
    // 사용자 위치 정보를 처리하는 위치 관리자
    var locationManager = CLLocationManager()
    // Naver 지도를 표시하는 지도 뷰
    var mapView: NMFNaverMapView!
    
    // 지도에 표시되는 마커
    let marker = NMFMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor4
        // 위치 관리자 설정 (델리게이트)
        locationManager.delegate = self
        
        // 네이버 지도 뷰 생성 및 설정
        mapView = NMFNaverMapView(frame: view.frame)
        mapView.showLocationButton = true // 현재 위치 버튼 표시
        mapView.positionMode = .direction // 지도를 기기의 방향에 따라 회전
        mapView.delegate = self // NMFMapViewDelegate 설정
        view.addSubview(mapView)
        
        // 기존 마커가 있는지 확인하고 지도에 표시합니다.
        marker.iconImage = NMFOverlayImage(name: "marker")
        marker.width = 40
        marker.height = 60
        
        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            // 마커가 탭되면 지도에서 제거하고 위치를 (0.0, 0.0)으로 저장합니다.
            self.marker.mapView = nil
            TodoManager.shared.position(tappedTodoId: TodoManager.tappedTodoId, lat: 0.0, lng: 0.0)
            return true
        }
        
        // TodoManager에서 현재 위치를 가져와 마커를 표시합니다.
        let currentPosition = TodoManager.shared.getPosition(tappedTodoId: TodoManager.tappedTodoId)
        if ( currentPosition != ""  && currentPosition != "0.0/0.0" && currentPosition != "0.000000/0.000000" ) {
            let currentPositionArr = currentPosition.split(separator: "/")
            
            marker.position = NMGLatLng(lat: Double(currentPositionArr[0])!, lng: Double(currentPositionArr[1])!)
            marker.mapView = mapView.mapView
            
            // 카메라를 마커의 위치로 이동합니다.
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: Double(currentPositionArr[0])!, lng: Double(currentPositionArr[1])!))
            mapView.mapView.moveCamera(cameraUpdate)
        }
        
        // 위치 서비스 설정 함수 호출
        locationSetting()
        
        // 닫기 버튼을 지도 뷰에 추가하고 제약조건을 설정합니다.
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            closeButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    // 닫기 버튼을 탭했을 때의 액션 메서드
    @objc func closeButtonTapped(latLng latlng: NMGLatLng) {
        
        //TODO: 투두 완료 시, 지오펜싱에서 제거하는 로직 추가
        
        let lat = Int(marker.position.lat)
        let lng = Int(marker.position.lng)

        if (lat != 0 && lng != 0) && marker.mapView != nil {
            // 마커가 찍혔을 시, 저장되게 처리
            TodoManager.shared.position(tappedTodoId: TodoManager.tappedTodoId, lat: marker.position.lat, lng: marker.position.lng)

            // 지오펜싱 등록
            let location = CLLocationCoordinate2D(latitude: marker.position.lat, longitude: marker.position.lng)
            let region = CLCircularRegion(center: location, radius: 300.0, identifier: TodoManager.tappedTodoId)
            region.notifyOnEntry = true
            region.notifyOnExit = true

            print(String(lat) + "/" + String(lng))

            locationManager.startMonitoring(for: region)
            dismiss(animated: true)
        }
        
        dismiss(animated: true)
    }
    
    // 위치 서비스를 설정하는 메서드
    private func locationSetting() {
        // 위치 업데이트 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 앱이 사용 중일 때만 위치 정보 액세스 권한 요청
        locationManager.requestWhenInUseAuthorization()
        requestAlwaysLocation()
        // 만약 iPhone 설정에서 위치 서비스가 활성화된 경우
        if CLLocationManager.locationServicesEnabled() {
            print("Location Services On")
            locationManager.startUpdatingLocation() // 위치 정보 업데이트 시작
            print(locationManager.location?.coordinate) // 현재 위치 좌표 출력
        } else {
            print("Location service off status")
        }
    }
    
    // 위치 정보를 계속 업데이트하고, 위도 및 경도를 확인
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let location = locations.first {
            // 업데이트된 위치의 위도와 경도를 출력합니다.
            print("Latitude: \(location.coordinate.latitude)")
            print("Longitude: \(location.coordinate.longitude)")
        }
    }
    
    // 위치 정보 업데이트 중 에러 발생 시 위도와 경도를 얻는 메서드 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // 지도가 탭되었을 때 호출되는 메서드
    func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
        // 탭된 위치에 마커 추가
        if marker.mapView == nil {
            marker.mapView = mapView.mapView
        }
        
        marker.position = NMGLatLng(lat: latlng.lat, lng:latlng.lng)
        // 탭한 마커의 위치를 출력합니다.
        print("this is pin position = " + String(format: "%f", marker.position.lat) + "///" + String(format: "%f", marker.position.lng))
        
        print(marker)
    }
    
    // 앱 사용 여부와 상관없이 위치 서비스 이용을 위해 사용자의 권한을 요청합니다.
    func requestAlwaysLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            locationManager.requestAlwaysAuthorization()
        default:
            print("Location is not available.")
        }
    }    
}
