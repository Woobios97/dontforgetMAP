//
//  LoginSheetViewController.swift
//  donforgetMAP
//
//  Created by 김우섭 on 2023/07/09.
//

import UIKit
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


class LoginSheetViewController: UIViewController {
    
    // 애플 로그인 버튼
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "apple-login"), for: .normal)
        return button
    }()
    
    // 카카오 로그인 버튼
    private let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao-login"), for: .normal)
        return button
    }()
    
    // 구글 로그인 버튼
    private let googleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "google-login"), for: .normal)
        return button
    }()
    
    
    private let loginTilte: UILabel = {
        let label = UILabel()
        label.text = "로그인 방법 선택"
        label.textAlignment = .center
        label.font = UIFont(name: "NanumSquareR", size: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor4
        configureUI()
    }
    // MARK: - UI
    private func configureUI() {
        setAdditionalPropertyAttributes()
        setConstraints()
    }
    
    private func setAdditionalPropertyAttributes() {
        appleLoginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButton(_:)), for: .touchUpInside)
        kakaoLoginButton.addTarget(self, action: #selector(handleAuthorizationKakaoIDButton), for: .touchUpInside)
        googleLoginButton.addTarget(self, action:#selector(handleAuthorizationGoogleIDButton), for: .touchUpInside)
    }
    
    private func setConstraints() {
        
        view.addSubview(loginTilte)
        loginTilte.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginTilte.widthAnchor.constraint(equalToConstant: 180),
            loginTilte.heightAnchor.constraint(equalToConstant: 40),
            loginTilte.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            loginTilte.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120)
        ])
        
        view.addSubview(kakaoLoginButton)
        kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            kakaoLoginButton.widthAnchor.constraint(equalToConstant: 180),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 40),
            kakaoLoginButton.topAnchor.constraint(equalTo: loginTilte.bottomAnchor, constant: 30),
            kakaoLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120)
        ])
        

        view.addSubview(appleLoginButton)
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appleLoginButton.widthAnchor.constraint(equalToConstant: 180),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 40),
            appleLoginButton.topAnchor.constraint(equalTo: kakaoLoginButton.bottomAnchor, constant: 10),
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120)
        ])
        
        view.addSubview(googleLoginButton)
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            googleLoginButton.widthAnchor.constraint(equalToConstant: 180),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 40),
            googleLoginButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 10),
            googleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120)
        ])
    }
    
    // MARK: - Selectors
    @objc private func handleAuthorizationAppleIDButton(_ sender: ASAuthorizationAppleIDButton) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc private func handleAuthorizationKakaoIDButton() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    let jwtToken = oauthToken

                    guard let jwtToken = oauthToken?.accessToken else {
                        print("error?")
                        return
                    }
                    
                    APIService.shared.authToken = jwtToken
                    
                    APIService.shared.snsLogin(snsProvider: "KAKAO") { result in
                        switch result {
                        case .success(_):
                            // navigate
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            guard let calendarContoller =
                                    storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
                            else {
                                return }

                            calendarContoller.modalPresentationStyle = .fullScreen
                            self.present(calendarContoller, animated: true, completion: nil)
                        case .failure(let failure):
                            // 예외처리
                            print(failure)
                            self.removeToken()
                        }
                    }
                }
            }
        }
    }
    
    @objc private func handleAuthorizationGoogleIDButton() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Google 로그인 구성 개체를 만듭니다.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        
            APIService.shared.snsLogin(snsProvider: "GOOGLE") { result in
                switch result {
                case .success(_):
                    //navigate
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    guard let calendarContoller =
                            storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
                    else {
                        return }

                    calendarContoller.modalPresentationStyle = .fullScreen
                    present(calendarContoller, animated: true, completion: nil)

                case .failure(let failure):
                    //예외처리
                    print(failure)
                    self.removeToken()
                }
            }
        }
    }
    
    
    private func removeToken() {
        APIService.shared.authToken = nil
    }
}

extension LoginSheetViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            
            guard let jwtToken = appleIDCredential.identityToken else {
                return
            }
            
//            let stringJwtToken = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8) -> identityToken은 Apple에서 제공하는 사용자의 인증 정보를 포함하는 JWT(JSON Web Token)이다. 이를 문자열로 변한하는 코드
            
            
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    // Apple ID 자격증명이 유효하다.
                    APIService.shared.snsLogin(snsProvider: "APPLE") { result in
                        switch result {
                        case .success(_):
                            //navigate
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            guard let calendarContoller =
                                    storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
                            else {
                                return }

                            calendarContoller.modalPresentationStyle = .fullScreen
                            self.present(calendarContoller, animated: true, completion: nil)
                        case .failure(let failure):
                            //예외처리
                            print(failure)
                            self.removeToken()
                        }
                    }
                    break
                case .revoked:
                    // The Apple ID credential is revoked. Show SignIn UI Here.
                    break
                case .notFound:
                    // No credential was found. Show SignIn UI Here.
                    break
                default:
                    break
                }
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print(error)
        }
    }
}


extension LoginSheetViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

