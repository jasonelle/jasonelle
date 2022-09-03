.PHONY: format archive icon docs

icon i:
	cp AppIcon.png ./App/App/Assets.xcassets/AppIcon.appiconset
	cd ./Tools && ./image-tool/make-icon

format f:
	cd ./Jasonelle && ./format

archive a:
	git archive --format=zip -9 -o latest.zip HEAD
