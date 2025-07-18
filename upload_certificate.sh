source config

while getopts "c:wm" OPTION
do
    case $OPTION in
    c)
        CLIENT_FOLDER=$OPTARG
        ;;
    esac
done

aws s3 cp s3://$BUCKET_NAME/$CLIENT_FOLDER/certfile.p12 .

openssl pkcs12 -in certfile.p12 -nodes -legacy -nocerts -passin pass: | openssl rsa -out cert_private_key

aws s3 cp cert_private_key s3://$BUCKET_NAME/$CLIENT_FOLDER/cert_private_key