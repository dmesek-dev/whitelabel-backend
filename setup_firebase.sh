source .config

while getopts "c:wm" OPTION
do
    case $OPTION in
    c)
        CLIENT_FOLDER=$OPTARG
        ;;
    esac
done

CONFIG_FILE=config.json
aws s3 cp s3://$BUCKET_NAME/$CLIENT_FOLDER/$CONFIG_FILE .

FIREBASE_CONFIG_ZIP_NAME="firebase_config.zip"
current_folder=$(pwd)
firebase_project_id=`jq -r '.FIREBASE_PROJECT_ID' $CONFIG_FILE`
bundle_id=`jq -r '.BUNDLE_ID' $CONFIG_FILE`
android_app_id=`jq -r '.ANDROID_APP_ID' $CONFIG_FILE`
macos_bundle_id=`jq -r '.MACOS_BUNDLE_ID' $CONFIG_FILE`
main_web_firebase_app_id=`jq -r '.MAIN_WEB_FIREBASE_APP_ID' $CONFIG_FILE`
windows_firebase_app_id=`jq -r '.WINDOWS_FIREBASE_APP_ID' $CONFIG_FILE`
cd $FLUTTER_MAIN_PROJECT_PATH
flutterfire configure -p $firebase_project_id --yes --platforms="ios, android, web, macos, windows" -i $bundle_id -a $android_app_id -m $macos_bundle_id -o firebase_options.dart -w $main_web_firebase_app_id -x $windows_firebase_app_id
mv firebase_options.dart $current_folder
mv android/app/google-services.json $current_folder
# Create separate folders for iOS and macOS GoogleService-Info.plist
mkdir -p $current_folder/ios
mkdir -p $current_folder/macos
mv ios/Runner/GoogleService-Info.plist $current_folder/ios/GoogleService-Info.plist
mv macos/Runner/GoogleService-Info.plist $current_folder/macos/GoogleService-Info.plist
mv firebase.json $current_folder
cd $current_folder
zip -rm $FIREBASE_CONFIG_ZIP_NAME firebase_options.dart google-services.json ios/GoogleService-Info.plist macos/GoogleService-Info.plist firebase.json

aws s3 cp $FIREBASE_CONFIG_ZIP_NAME s3://$BUCKET_NAME/$CLIENT_FOLDER/$FIREBASE_CONFIG_ZIP_NAME
rm $CONFIG_FILE $FIREBASE_CONFIG_ZIP_NAME
