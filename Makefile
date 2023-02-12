.PHONY: docs

docs d:
# Copy the documentation of the iOS components
	@cp README.md ./docs/src/about.md
	@cp ./sources/xcode/Extensions/JLApplicationBadge/JLApplicationBadge/JLApplicationBadge.docc/JLApplicationBadge.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLATTrackingManager/JLATTrackingManager/JLATTrackingManager.docc/JLATTrackingManager.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLCookies/JLCookies/JLCookies.docc/JLCookies.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLKeychain/JLKeychain/JLKeychain.docc/JLKeychain.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLPhotoLibrary/JLPhotoLibrary/JLPhotoLibrary.docc/JLPhotoLibrary.md ./docs/src/xcode
	@cp ./sources/xcode/Extensions/JLContacts/JLContacts/JLContacts.docc/JLContacts.md ./docs/src/xcode

	cd docs && mdbook build
