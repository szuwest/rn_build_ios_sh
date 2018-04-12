#!/bin/bash -ilex

#计时
SECONDS=0

#假设脚本放置在与项目相同的路径下
project_path=$(pwd)
#取当前时间字符串添加到文件结尾
now=$(date +"%Y_%m_%d_%H_%M_%S")

projectName="VprScene"
#指定项目的scheme名称
scheme="VprScene"
#指定要打包的配置名
configuration="Release"
#指定打包所使用的provisioning profile名称
exportOptionsPlistPath='./ExportOptions.plist'

#指定项目地址
workspace_path="$project_path/${projectName}.xcodeproj"
#指定输出路径
output_path="$HOME/Desktop/${projectName}"
#指定输出归档文件地址
archive_path="$output_path/${projectName}_${now}.xcarchive"
#指定输出ipa地址
ipa_path="$output_path/${projectName}_${now}.ipa"
#full path
ipa_full_path="$output_path/${projectName}_${now}.ipa/${projectName}.ipa"
#获取执行命令时的commit message
commit_msg="$1"

#输出设定的变量值
echo "===workspace path: ${workspace_path}==="
echo "===archive path: ${archive_path}==="
echo "===ipa path: ${ipa_path}==="
echo "===profile: ${provisioning_profile}==="
echo "===commit msg: $1==="

#react-native yarn
yarn install --registry http://192.168.0.9

#cocoapods
#pod install --no-repo-update

#先清空前一次build
xcodebuild -project ${workspace_path} -scheme ${scheme} -configuration ${configuration} clean

#根据指定的项目、scheme、configuration与输出路径打包出archive文件
xcodebuild -project ${workspace_path} -scheme ${scheme} -configuration ${configuration} archive -archivePath ${archive_path} build

#使用指定的provisioning profile导出ipa
#我暂时没找到xctool指定provisioning profile的方法，所以这里用了xcodebuild
xcodebuild -exportArchive -archivePath ${archive_path} -exportPath ${ipa_path} -exportOptionsPlist "${exportOptionsPlistPath}"

#上传到pgyer
#蒲公英上的User Key
uKey="d0876958a45db884c287d85ab032bb01"
#蒲公英上的API Key
apiKey="8fdec42be987c001f6cf27b815cccbb4"
#执行上传至蒲公英的命令
echo "++++++++++++++upload+++++++++++++"
curl -F "file=@${ipa_full_path}" -F "uKey=${uKey}" -F "_api_key=${apiKey}" https://qiniu-storage.pgyer.com/apiv1/app/upload

#输出总用时
echo "===Finished. Total time: ${SECONDS}s==="
