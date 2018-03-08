#!/bin/bash -ilex

#设置超时
export FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT=120

#计时
SECONDS=0

#假设脚本放置在与iOS项目相同的路径下
#project_path="$(dirname "$(pwd)")"
project_path="$(pwd)"
#取当前时间字符串添加到文件结尾
now=$(date +"%Y_%m_%d_%H_%M_%S")
#项目名称
projectName="VprScene"

#指定项目的scheme名称
scheme="VprScene"
#指定要打包的配置名
configuration="Release"
#指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数
export_method='ad-hoc'

#指定项目地址，如果是workspace，需要修改
workspace_path="$project_path/${projectName}.xcodeproj"
#指定输出路径
output_path="/Users/xhkj/Desktop/${projectName}"
#指定输出归档文件地址
archive_path="$output_path/${projectName}_${now}.xcarchive"
#指定输出ipa地址
ipa_path="$output_path/${projectName}_${now}.ipa"
#指定输出ipa名称
ipa_name="${projectName}_${now}.ipa"
#获取执行命令时的commit message
commit_msg="$1"

#输出设定的变量值
echo "===workspace path: ${workspace_path}==="
echo "===archive path: ${archive_path}==="
echo "===ipa path: ${ipa_path}==="
echo "===export method: ${export_method}==="
echo "===commit msg: $1==="

# 解锁对login.keychain的访问，codesign会用到，需要替换为实际密码
security unlock-keychain -p "123456" $HOME/Library/Keychains/login.keychain

#react-native yarn 
#yarn install --registry http://192.168.0.9
yarn install

#cocoapods
#pod install --no-repo-update


#fasltlane build，注意如果是cocoapods工程需要修改命令
fastlane gym --project ${workspace_path} --scheme ${scheme} --clean --configuration ${configuration} --archive_path ${archive_path} --export_method ${export_method} -allowProvisioningUpdates --output_directory ${output_path} --output_name ${ipa_name}

#上传到pgyer
#蒲公英上的User Key
uKey="xxxxxxxxxxxxxxxxxxxx"
#蒲公英上的API Key
apiKey="xxxxxxxxxxxxxxxxxxxxx"
#执行上传至蒲公英的命令
echo "++++++++++++++upload+++++++++++++"
curl -F "file=@${ipa_path}" -F "uKey=${uKey}" -F "_api_key=${apiKey}" https://qiniu-storage.pgyer.com/apiv1/app/upload

#输出总用时
echo "===Finished. Total time: ${SECONDS}s==="
