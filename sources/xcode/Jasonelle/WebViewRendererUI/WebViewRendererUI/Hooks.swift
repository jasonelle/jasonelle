//
//  Hooks.swift
//  WebViewRendererUI
//
//  Created by clsource on 24-04-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
//

import Foundation
import JLKernel

// Hooks for the Main Component

class HooksParams {
    let params: JLJSParams

    init(_ params: JLJSParams) {
        self.params = params
    }

    func onOrientationChange() -> JLJSParams {
        return params.get("onOrientationChange")
    }

    func onAppDidEnterBackground() -> JLJSParams {
        return params.get("onBackground")
    }

    func onAppWillEnterForeground() -> JLJSParams {
        return params.get("onForeground")
    }

    func onAppDidLoad() -> JLJSParams {
        return params.get("onLoad")
    }

    func onViewDidAppear() -> JLJSParams {
        return params.get("onAppear")
    }

    func onViewDidDisappear() -> JLJSParams {
        return params.get("onDisappear")
    }
}

class Hooks {
    let events: JLApplicationEvents
    let params: HooksParams

    init(_ events: JLApplicationEvents, params: JLJSParams) {
        self.params = HooksParams(params)
        self.events = events

        addOnOrientationChangeHook()
        addAppDidEnterBackgroundHook()
        addAppWillEnterForegroundHook()

        // Set the hooks in the app instance
        App.instance.hooks = params
    }

    // MARK: - Public

    // MARK: App Did Load Hook

    @objc
    func onAppDidLoad() {
        // Call JS with the notification info
        let event = events.event(for: JLEventAppDidLoad.self)

        // This event only needs to be triggered once
        if event?.triggered == true {
            return
        }

        let hook = params.onAppDidLoad()
        let function = hook.value
        function.secureCall(with: event?.event)

        event?.triggerOnce()
    }

    // MARK: App Did Appear Hook

    @objc
    func onViewDidAppear() {
        let event = events.event(for: JLEventViewDidAppear.self)

        let hook = params.onViewDidAppear()
        let function = hook.value
        function.secureCall(with: event?.event)
    }

    // MARK: View Did Disappear Hook

    @objc
    func onViewDidDisappear() {
        let event = events.event(for: JLEventViewDidDisappear.self)

        let hook = params.onViewDidDisappear()
        let function = hook.value
        function.secureCall(with: event?.event)
    }

    // MARK: - Private

    // MARK: App Will Enter Background Hook

    private func addAppDidEnterBackgroundHook() {
        if !params.onAppDidEnterBackground().value.canCall() {
            return
        }

        events.addListener(self,
                           with: #selector(onAppDidEnterBackground(notification:)),
                           for: JLEventAppDidEnterBackground.self)
    }

    @objc
    private func onAppDidEnterBackground(notification: Notification) {
        // Call JS with the notification info
        let event = params.onAppDidEnterBackground()
        let function = event.value
        function.secureCall(with: notification.userInfo)
    }

    // MARK: App Will Enter Foreground Hook

    private func addAppWillEnterForegroundHook() {
        if !params.onAppWillEnterForeground().value.canCall() {
            return
        }

        events.addListener(self,
                           with: #selector(onAppWillEnterForeground(notification:)),
                           for: JLEventAppWillEnterForeground.self)
    }

    @objc
    private func onAppWillEnterForeground(notification: Notification) {
        // Call JS with the notification info
        let event = params.onAppWillEnterForeground()
        let function = event.value
        function.secureCall(with: notification.userInfo)
    }

    // MARK: Orientation Did Change Hook

    private func addOnOrientationChangeHook() {
        // Only start listening to orientation change events
        // if the value is a callable function
        if !params.onOrientationChange().value.canCall() {
            return
        }

        let event: JLEventOrientationDidChange? = events.event(for: JLEventOrientationDidChange.self) as? JLEventOrientationDidChange

        event?.startMonitoring()

        events.addListener(self,
                           with: #selector(onOrientationDidChange(notification:)),
                           for: JLEventOrientationDidChange.self)
    }

    @objc
    private func onOrientationDidChange(notification: Notification) {
        // Call JS with the notification info
        let event = params.onOrientationChange()
        let function = event.value
        function.secureCall(with: notification.userInfo)
    }
}
