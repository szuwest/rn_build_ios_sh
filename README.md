# rn_build_ios_sh
react-native 项目iOS自动打包脚本
 这个脚本是专门给react-native项目打包使用的。
 可以指定导出方式，例如ad-hoc
 可以上传到蒲公英。
 
 这里需要注意的是填入访问keychain的密码，不然会导致签名失败
 
 打包命令用的是fastlane。
 
 还有在脚本的开头 加入了 -ilex，这个是说明要交互的shell。
 在Jenkins中打包不加这个命令可能会失败
 
 如果往证书里加了新设备，要更新打包机上的证书。先把本地的Provisioning Profiles都删掉，然后打开xcode工程，它会自动重新生成新的Provisioning Profiles。这时候再通过脚本打包，就没问题了
 
 # build_using_xctool
 这是完全由xcodebuild来编译IPA方式，不需要安装别的工具。
