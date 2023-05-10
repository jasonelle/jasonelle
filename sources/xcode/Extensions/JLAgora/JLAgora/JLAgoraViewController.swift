//
//  JLAgoraViewController.swift
//  JLAgora
//
//  Created by clsource on 10-05-23.
//  Copyright (c) Jasonelle.com

import UIKit
import AgoraUIKit

// From https://docs.agora.io/en/interactive-live-streaming/get-started/get-started-uikit?platform=ios#initialize-an-agoravideoviewer-instance-and-join-a-channel

@objc
public class JLAgoraViewController: UIViewController {

    
    // Fill the App ID of your project generated on Agora Console.
    var appId: String = ""

    // Fill the temp token generated on Agora Console.
    var token: String? = ""

    // Fill the channel name.
    var channelName: String = ""

    // Create the view object.
    var agoraView: AgoraVideoViewer!
    
    @objc
    public func setup(appId: String, token: String, channel: String) {
        self.appId = appId
        self.token = token
        self.channelName = channel
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initializeAndJoinChannel()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        agoraView.exit()
    }
    
    func initializeAndJoinChannel() {

        agoraView = AgoraVideoViewer(
            connectionData: AgoraConnectionData(
                appId: appId,
                rtcToken: token
            )
        )
        agoraView.fills(view: self.view)

        agoraView.join(
            channel: channelName,
            with: token,
            as: .broadcaster
        )
    }
}
