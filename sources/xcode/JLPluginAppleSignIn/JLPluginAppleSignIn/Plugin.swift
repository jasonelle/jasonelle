//
//  Plugin.swift
//  JLPluginAppleSignIn
//
//  Created by Camilo on 15-09-26.
//

import AuthenticationServices
import Foundation
import JLKernel

#if os(iOS)
import UIKit
#endif

public final class Plugin: JLKernel.Plugin {
  override public static var name: String { "applesignin" }

  private var activeCoordinator: AuthCoordinator?

  #if os(iOS)
  private weak var nativeButton: ASAuthorizationAppleIDButton?
  #endif

  public override func handle_call(
    callbackId: String,
    args: [String: Any]? = [:],
    respond: @escaping (String) -> Void
  ) {
    let action = args?["action"] as? String ?? ""
    self.logger.info("Handling action '\(action)' with args: \(String(describing: args))")

    switch action {
    case "signIn":
      self.performSignIn(callbackId: callbackId, args: args, respond: respond)

    case "getCredentialState":
      self.performGetCredentialState(callbackId: callbackId, args: args, respond: respond)

    #if os(iOS)
    case "showNativeButton":
      if Thread.isMainThread {
        MainActor.assumeIsolated {
          self.showNativeButton(callbackId: callbackId, args: args, respond: respond)
        }
      } else {
        DispatchQueue.main.async {
          self.showNativeButton(callbackId: callbackId, args: args, respond: respond)
        }
      }

    case "hideNativeButton":
      if Thread.isMainThread {
        MainActor.assumeIsolated {
          self.hideNativeButton(callbackId: callbackId, respond: respond)
        }
      } else {
        DispatchQueue.main.async {
          self.hideNativeButton(callbackId: callbackId, respond: respond)
        }
      }
    #endif

    default:
      self.logger.warning("Unknown action '\(action)'")
      self.reject(
        args: ["error": "Unknown action '\(action)'"],
        callbackId: callbackId,
        status: "error",
        respond: respond
      )
    }
  }

  // MARK: - Sign In Flow

  private func performSignIn(
    callbackId: String,
    args: [String: Any]?,
    respond: @escaping (String) -> Void
  ) {
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()

    // Configure requested scopes (default: fullName and email)
    if let scopesArg = args?["scopes"] as? [String] {
      var scopes: [ASAuthorization.Scope] = []
      for scope in scopesArg {
        switch scope.lowercased() {
        case "fullname", "name":
          scopes.append(.fullName)
        case "email":
          scopes.append(.email)
        default:
          break
        }
      }
      request.requestedScopes = scopes
    } else {
      request.requestedScopes = [.fullName, .email]
    }

    // Configure optional nonce
    if let nonce = args?["nonce"] as? String {
      request.nonce = nonce
    }

    // Configure optional state
    if let state = args?["state"] as? String {
      request.state = state
    }

    // Configure optional user for re-authentication
    if let user = args?["user"] as? String {
      request.user = user
    }

    let controller = ASAuthorizationController(authorizationRequests: [request])

    let coordinator = AuthCoordinator(
      plugin: self,
      callbackId: callbackId,
      respond: respond
    )
    self.activeCoordinator = coordinator

    controller.delegate = coordinator
    controller.presentationContextProvider = coordinator

    DispatchQueue.main.async {
      controller.performRequests()
    }
  }

  // MARK: - Credential State

  private func performGetCredentialState(
    callbackId: String,
    args: [String: Any]?,
    respond: @escaping (String) -> Void
  ) {
    guard let userID = (args?["userID"] as? String) ?? (args?["user"] as? String),
          !userID.isEmpty else {
      self.reject(
        args: ["error": "Missing 'userID' parameter"],
        callbackId: callbackId,
        status: "error",
        respond: respond
      )
      return
    }

    let provider = ASAuthorizationAppleIDProvider()
    provider.getCredentialState(forUserID: userID) { [weak self] state, error in
      guard let self = self else { return }

      if let error = error {
        self.reject(
          args: ["error": error.localizedDescription],
          callbackId: callbackId,
          status: "error",
          respond: respond
        )
        return
      }

      let stateString: String
      switch state {
      case .authorized:
        stateString = "authorized"
      case .revoked:
        stateString = "revoked"
      case .notFound:
        stateString = "notFound"
      case .transferred:
        stateString = "transferred"
      @unknown default:
        stateString = "unknown"
      }

      self.resolve(
        args: ["status": "ok", "state": stateString],
        callbackId: callbackId,
        respond: respond
      )
    }
  }

  // MARK: - Native Button Controller (iOS)

  #if os(iOS)
  @MainActor
  private func showNativeButton(
    callbackId: String,
    args: [String: Any]?,
    respond: @escaping (String) -> Void
  ) {
    guard let window = self.keyWindow() else {
      self.reject(
        args: ["error": "Unable to find active window for button display"],
        callbackId: callbackId,
        status: "error",
        respond: respond
      )
      return
    }

    self.nativeButton?.removeFromSuperview()

    let buttonType = self.parseButtonType(args?["type"] as? String)
    let buttonStyle = self.parseButtonStyle(args?["style"] as? String)

    let button = ASAuthorizationAppleIDButton(type: buttonType, style: buttonStyle)
    if let cornerRadius = args?["cornerRadius"] as? CGFloat {
      button.cornerRadius = cornerRadius
    }

    let x = (args?["x"] as? CGFloat) ?? 20
    let y = (args?["y"] as? CGFloat) ?? (window.bounds.height - 100)
    let width = (args?["width"] as? CGFloat) ?? (window.bounds.width - 40)
    let height = (args?["height"] as? CGFloat) ?? 50

    button.frame = CGRect(x: x, y: y, width: width, height: height)
    button.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    button.addTarget(self, action: #selector(self.handleNativeButtonTap), for: .touchUpInside)

    window.addSubview(button)
    self.nativeButton = button

    self.resolve(args: ["status": "ok"], callbackId: callbackId, respond: respond)
  }

  @MainActor
  private func hideNativeButton(
    callbackId: String,
    respond: @escaping (String) -> Void
  ) {
    self.nativeButton?.removeFromSuperview()
    self.nativeButton = nil
    self.resolve(args: ["status": "ok"], callbackId: callbackId, respond: respond)
  }

  @objc private func handleNativeButtonTap() {
    self.logger.info("Native Apple Sign In button tapped")
    self.performSignIn(callbackId: "native_button_tap", args: nil) { [weak self] script in
      guard let self = self else { return }
      self.logger.debug("Native button sign in completed, script: \(script)")
    }
  }

  private func parseButtonType(_ typeStr: String?) -> ASAuthorizationAppleIDButton.ButtonType {
    switch typeStr?.lowercased() {
    case "continue":
      return .continue
    case "signup", "sign_up":
      return .signUp
    default:
      return .signIn
    }
  }

  private func parseButtonStyle(_ styleStr: String?) -> ASAuthorizationAppleIDButton.Style {
    switch styleStr?.lowercased() {
    case "white":
      return .white
    case "whiteoutline", "white_outline":
      return .whiteOutline
    default:
      return .black
    }
  }

  @MainActor
  fileprivate func keyWindow() -> UIWindow? {
    let scenes = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
    for scene in scenes where scene.activationState == .foregroundActive {
      if let window = scene.windows.first(where: { $0.isKeyWindow }) {
        return window
      }
    }
    return scenes.flatMap { $0.windows }.first { $0.isKeyWindow }
  }
  #endif

  fileprivate func clearCoordinator() {
    self.activeCoordinator = nil
  }
}

// MARK: - AuthCoordinator

private final class AuthCoordinator: NSObject,
  ASAuthorizationControllerDelegate,
  ASAuthorizationControllerPresentationContextProviding {

  private weak var plugin: Plugin?
  private let callbackId: String
  private let respond: (String) -> Void

  init(plugin: Plugin, callbackId: String, respond: @escaping (String) -> Void) {
    self.plugin = plugin
    self.callbackId = callbackId
    self.respond = respond
    super.init()
  }

  // MARK: ASAuthorizationControllerDelegate

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard let plugin = self.plugin else { return }
    defer { plugin.clearCoordinator() }

    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
      var result: [String: Any] = [
        "user": credential.user,
        "status": "ok"
      ]

      if let email = credential.email {
        result["email"] = email
      }

      if let fullName = credential.fullName {
        var nameDict: [String: Any] = [:]
        if let givenName = fullName.givenName { nameDict["givenName"] = givenName }
        if let familyName = fullName.familyName { nameDict["familyName"] = familyName }
        if let middleName = fullName.middleName { nameDict["middleName"] = middleName }
        if let prefix = fullName.namePrefix { nameDict["namePrefix"] = prefix }
        if let suffix = fullName.nameSuffix { nameDict["nameSuffix"] = suffix }
        if let nickname = fullName.nickname { nameDict["nickname"] = nickname }

        let formatted = PersonNameComponentsFormatter().string(from: fullName)
        if !formatted.isEmpty { nameDict["formatted"] = formatted }

        result["fullName"] = nameDict
      }

      if let tokenData = credential.identityToken,
         let tokenString = String(data: tokenData, encoding: .utf8) {
        result["identityToken"] = tokenString
      }

      if let codeData = credential.authorizationCode,
         let codeString = String(data: codeData, encoding: .utf8) {
        result["authorizationCode"] = codeString
      }

      if let state = credential.state {
        result["state"] = state
      }

      switch credential.realUserStatus {
      case .likelyReal:
        result["realUserStatus"] = "likelyReal"
      case .unknown:
        result["realUserStatus"] = "unknown"
      case .unsupported:
        result["realUserStatus"] = "unsupported"
      @unknown default:
        result["realUserStatus"] = "unknown"
      }

      if !credential.authorizedScopes.isEmpty {
        result["authorizedScopes"] = credential.authorizedScopes.compactMap { scope -> String? in
          if scope == .email { return "email" }
          if scope == .fullName { return "fullName" }
          return nil
        }
      }

      plugin.resolve(args: result, callbackId: self.callbackId, respond: self.respond)

    } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
      let result: [String: Any] = [
        "user": passwordCredential.user,
        "password": passwordCredential.password,
        "type": "password",
        "status": "ok"
      ]
      plugin.resolve(args: result, callbackId: self.callbackId, respond: self.respond)
    } else {
      plugin.reject(
        args: ["error": "Unsupported authorization credential type"],
        callbackId: self.callbackId,
        status: "error",
        respond: self.respond
      )
    }
  }

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    guard let plugin = self.plugin else { return }
    defer { plugin.clearCoordinator() }

    var errorCode = 0
    var isCanceled = false

    if let authError = error as? ASAuthorizationError {
      errorCode = authError.errorCode
      isCanceled = (authError.code == .canceled)
    }

    plugin.reject(
      args: [
        "error": error.localizedDescription,
        "code": errorCode,
        "canceled": isCanceled
      ],
      callbackId: self.callbackId,
      status: "error",
      respond: self.respond
    )
  }

  // MARK: ASAuthorizationControllerPresentationContextProviding

  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    #if os(iOS)
    if Thread.isMainThread {
      return MainActor.assumeIsolated {
        self.plugin?.keyWindow() ?? UIWindow()
      }
    } else {
      return DispatchQueue.main.sync {
        MainActor.assumeIsolated {
          self.plugin?.keyWindow() ?? UIWindow()
        }
      }
    }
    #else
    return ASPresentationAnchor()
    #endif
  }
}
