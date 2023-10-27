//
//  AlertViewController.swift
//  donforgetMAP
//
//  Created by 김우섭 on 2023/07/29.
//

import UIKit

@available(iOS 16, *)
class AlertViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor4
        contentView.layer.cornerRadius = 30
        textField.delegate = self
        errorMessageLabel.isHidden = true
    }
    
    
    @IBAction func cancleTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func membershipWithdrawalTapped(_ sender: UIButton) {
        textField.becomeFirstResponder()
        let status = true   // true
        
        if let userDeleteTx = textField.text {
            let withdrawalCheckText = "탈퇴하겠습니다"
            // 텍스트필드에 탈퇴하겠습니다가 똑같다면, true -> false // x, false -> true
            
            let isSame = withdrawalCheckText == userDeleteTx
            
            if isSame {
                APIService.shared.userDelete { result in
                    switch result {
                    case .success(_):
                        print("This is success userdelete")
                        self.errorMessageLabel.isHidden = true
                        UserDefaults.standard.removeObject(forKey: "JWT")
                        APIService.shared.authToken = nil
                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
                        onboardingVC.modalPresentationStyle = .fullScreen
                        self.present(onboardingVC, animated: true, completion: nil)
                    case .failure(let failure):
                        print("This is success userdelete")
                        print(failure)
                    }
                }
            } else {
                errorMessageLabel.isHidden = false
                textField.resignFirstResponder()
            }
        }
    }
}
