.PHONY: format archive icon permissions

icon i:
	cp AppIcon.png ./App/App/Assets.xcassets/AppIcon.appiconset
	cd ./Tools && ./image-tool/make-icon

format f:
	cd ./Jasonelle && ./format

archive a:
	git archive --format=zip -9 -o latest.zip HEAD

# Fix "bad interpreter: Operation not permitted" errors
permissions p:
	cd Tools && sudo xattr -rc .
	cd App/Tools && sudo xattr -rc .
