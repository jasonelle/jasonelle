.PHONY: docs

docs d:
# Copy the documentation of the iOS components
	@cp README.md ./docs/src/About.md
	@cp ./sources/xcode/CHANGELOG.md ./docs/src/xcode/Changelog.md
	@cp ./sources/xcode/README.md ./docs/src/xcode/Quickstart.md
	@cp ./sources/xcode/Extensions/JLApplicationBadge/JLApplicationBadge/JLApplicationBadge.docc/JLApplicationBadge.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLATTrackingManager/JLATTrackingManager/JLATTrackingManager.docc/JLATTrackingManager.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLCookies/JLCookies/JLCookies.docc/JLCookies.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLKeychain/JLKeychain/JLKeychain.docc/JLKeychain.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLPhotoLibrary/JLPhotoLibrary/JLPhotoLibrary.docc/JLPhotoLibrary.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLContacts/JLContacts/JLContacts.docc/JLContacts.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLReachability/JLReachability/JLReachability.docc/JLReachability.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLAudio/JLAudio/JLAudio.docc/JLAudio.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLDevice/JLDevice/JLDevice.docc/JLDevice.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLClipboard/JLClipboard/JLClipboard.docc/JLClipboard.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLToast/JLToast/JLToast.docc/JLToast.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLShare/JLShare/JLShare.docc/JLShare.md ./docs/src/xcode

	cd docs && mdbook build
