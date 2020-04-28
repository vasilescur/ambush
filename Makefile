ARCH=amd64-darwin

ambush: ambush.$(ARCH)
	echo "sml @SMLload ambush.$(ARCH) \$$1" > ./ambush && chmod +x ./ambush 

ambush.$(ARCH): sources.cm
	ml-build sources.cm Main.main ambush

clean:
	rm testcases/*.s && rm ./ambush.* && rm ./ambush