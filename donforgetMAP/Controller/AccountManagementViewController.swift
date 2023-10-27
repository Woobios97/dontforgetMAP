//
//  AccountManagementViewController.swift
//  donforgetMAP
//
//  Created by 김우섭 on 2023/07/27.
//

import UIKit

class AccountManagementViewController: UIViewController {
    
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var membershipWithdrawalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor4
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.backward.fill"), style: .plain, target: self, action: #selector(didTapSetting))
        navigationItem.leftBarButtonItem?.tintColor = .primaryColor1
        dismiss(animated: true)
    }
    
    @objc private func didTapSetting() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func membershipWithDrawalTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        // 스토리보드 가져오기
        let alertPopVC = storyboard.instantiateViewController(withIdentifier: "AlertViewController")
        // 스토리보드를 통해 뷰컨트롤러 가져오기
        alertPopVC.modalPresentationStyle = .overCurrentContext
        // 뷰컨트롤러가 보여지는 스타일
        alertPopVC.modalTransitionStyle = .crossDissolve

        self.present(alertPopVC, animated: true)
    }


    @IBAction func logout(_ sender: Any) {
        
        //TODO: 로그아웃 처리
        APIService.shared.logout { result in
            switch result {
            case .success(let success):
                UserDefaults.standard.removeObject(forKey: "JWT")
                APIService.shared.authToken = nil
                self.navigationController?.popToRootViewController(animated: true)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
