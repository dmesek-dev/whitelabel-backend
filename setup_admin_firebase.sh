while getopts "c:wm" OPTION
do
    case $OPTION in
    c)
        CLIENT_FOLDER=$OPTARG
        ;;
    esac
done

BUCKET_NAME=test-whitelabels
FLUTTER_ADMIN_PROJECT_PATH=/home/ubuntu/sea_trials_universal/apps/admin_app
CONFIG_FILE=config.json
aws s3 cp s3://$BUCKET_NAME/$CLIENT_FOLDER/$CONFIG_FILE .

ADMIN_FIREBASE_CONFIG_ZIP_NAME="admin_firebase_config.zip"
current_folder=$(pwd)
firebase_project_id=`jq -r '.FIREBASE_PROJECT_ID' $CONFIG_FILE`
admin_web_firebase_app_id=`jq -r '.ADMIN_WEB_FIREBASE_APP_ID' $CONFIG_FILE`
cd $FLUTTER_ADMIN_PROJECT_PATH
flutterfire configure -e $DEFAULT_FIREBASE_ACCOUNT -p $firebase_project_id --yes --platforms="web" -o firebase_options.dart -w $admin_web_firebase_app_id
mv firebase_options.dart $current_folder
mv firebase.json $current_folder
cd $current_folder
zip -rm $ADMIN_FIREBASE_CONFIG_ZIP_NAME firebase_options.dart firebase.json

aws s3 cp $ADMIN_FIREBASE_CONFIG_ZIP_NAME s3://$BUCKET_NAME/$CLIENT_FOLDER/$ADMIN_FIREBASE_CONFIG_ZIP_NAME
rm $CONFIG_FILE $ADMIN_FIREBASE_CONFIG_ZIP_NAME