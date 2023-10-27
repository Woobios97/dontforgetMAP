//
//  SettingViewController.swift
//  donforgetMAP
//
//  Created by 김우섭 on 2023/07/11.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var accountManage: UIView!
    @IBOutlet weak var notificationManage: UIView!
    @IBOutlet weak var version: UIView!
    @IBOutlet weak var contact: UIView!
    
    @IBOutlet weak var toggleButton: UISwitch!
    
    var notiStatus: Bool?
    
    let NOTIKEY = "isNotiOn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor4
 
        conf()
        
        // 이전에 저장한 설정 값을 불러옵니다.
        if UserDefaults.standard.object(forKey: NOTIKEY) == nil {
            notiStatus = true
        } else {
            notiStatus = UserDefaults.standard.bool(forKey: NOTIKEY)
        }
        
        // 토글 버튼 상태를 설정 값에 따라 변경합니다.
        toggleButton.setOn(notiStatus!, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.backward.fill"), style: .plain, target: self, action: #selector(didTapSetting))
        navigationItem.leftBarButtonItem?.tintColor = .primaryColor1
        dismiss(animated: true)
    }
    
    @objc private func didTapSetting() {
        navigationController?.popViewController(animated: true)
    }
    
    private func conf() {
        let accountTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAccountManage))
        accountManage.addGestureRecognizer(accountTapGesture)
                
        let contactTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapContact))
        contact.addGestureRecognizer(contactTapGesture)
    }
    
    @objc func tapAccountManage() {
        guard let settingVC = storyboard?.instantiateViewController(withIdentifier: "AccountManagementViewController") as? AccountManagementViewController else { return }
        settingVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func tapContact() {
        //이메일 보내기
        if MFMailComposeViewController.canSendMail() {
            
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            
            compseVC.setToRecipients(["one.month.one.project@gmail.com"])
            compseVC.setSubject("Message Subject")
            compseVC.setMessageBody("Message Content", isHTML: false)
            
            self.present(compseVC, animated: true, completion: nil)
            
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "문의 전송 실패", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleButtonChanged(_ sender: UISwitch) {
        // 설정 값을 UserDefaults에 저장합니다.
        UserDefaults.standard.set(toggleButton.isOn, forKey: NOTIKEY)
    }
    
    
    
}

