//
//  ViewController.swift
//  donforgetMAP
//
//  Created by 김우섭 on 2023/07/07.
//

import UIKit

@available(iOS 16, *)
class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var sublogoLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor4
        print("시작")
        print("jwt - " + (APIService.shared.authToken ?? ""))
        
        //TODO: jwt 토큰 만료 및 갱신 로직 추가
        if ( APIService.shared.authToken != nil ) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let calendarContoller =
                    storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
            else {
                return }

            self.navigationItem.hidesBackButton = true
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.navigationController?.pushViewController(calendarContoller, animated: true)
        }
        
        UIConfigure()
    }
    
    func UIConfigure() {
        
        logoLabel.textColor = .primaryColor1
        sublogoLabel.textColor = .primaryColor5
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        loginButton.backgroundColor = .primaryColor1
        loginButton.topAnchor.constraint(equalTo: sublogoLabel.bottomAnchor, constant: 150).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 215).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        guestButton.setTitleColor(.primaryColor5, for: .normal)
        guestButton.layer.cornerRadius = 20
        guestButton.clipsToBounds = true
        guestButton.layer.borderColor = UIColor.gray.cgColor
        guestButton.layer.borderWidth = 1
        guestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        guestButton.widthAnchor.constraint(equalToConstant: 215).isActive = true
        guestButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //TODO: WooBi 스토리보드 -> 게스트 로그인 to 캘린더뷰 세그 제거 부탁드립니다~
    @IBAction func guestLoginTapped(_ sender: Any) {
        APIService.shared.snsLogin(snsProvider: "GUEST") { result in
            switch result {
            case .success(_):
                guard let calendarController = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController else { return }
                self.navigationController?.pushViewController(calendarController, animated: true)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        let loginViewVC = LoginSheetViewController()
        if let sheet = loginViewVC.sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return 260
                }
            ]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        self.present(loginViewVC, animated: true) {
            
        }
    }
    
    
    
}

