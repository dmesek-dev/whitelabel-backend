BUCKET_NAME=seatrials-whitelabels
FLUTTER_MAIN_PROJECT_PATH=/home/ubuntu/sea_trials_universal/apps/main_app
FLUTTER_ADMIN_PROJECT_PATH=/home/ubuntu/sea_trials_universal/apps/admin_panel

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
aws s3 cp s3://$BUCKET_NAME/$CLIENT_FOLDER/firebase-service-account.json .
unset FIREBASE_TOKEN


ADMIN_FIREBASE_CONFIG_ZIP_NAME="admin_firebase_config.zip"
current_folder=$(pwd)
firebase_project_id=`jq -r '.FIREBASE_PROJECT_ID' $CONFIG_FILE`
admin_web_firebase_app_id=`jq -r '.ADMIN_WEB_FIREBASE_APP_ID' $CONFIG_FILE`
cd $FLUTTER_ADMIN_PROJECT_PATH

export GOOGLE_APPLICATION_CREDENTIALS="$current_folder/firebase-service-account.json"
gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"

flutterfire configure -p $firebase_project_id --yes --platforms="web" -o firebase_options.dart -w $admin_web_firebase_app_id
mv firebase_options.dart $current_folder
mv firebase.json $current_folder
cd $current_folder
zip -rm $ADMIN_FIREBASE_CONFIG_ZIP_NAME firebase_options.dart firebase.json

aws s3 cp $ADMIN_FIREBASE_CONFIG_ZIP_NAME s3://$BUCKET_NAME/$CLIENT_FOLDER/$ADMIN_FIREBASE_CONFIG_ZIP_NAME
rm $CONFIG_FILE $ADMIN_FIREBASE_CONFIG_ZIP_NAME
