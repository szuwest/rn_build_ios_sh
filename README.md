# rn_build_ios_sh
react-native 项目iOS自动打包脚本
 这个脚本是专门给react-native项目打包使用的。
 可以指定导出方式，例如ad-hoc
 可以上传到蒲公英。
 
 这里需要注意的是填入访问keychain的密码，不然会导致签名失败
 
 打包命令用的是fastlane。
 
 还有在脚本的开头 加入了 -ilex，这个是说明要交互的shell。
 在Jenkins中打包不加这个命令可能会失败
 
