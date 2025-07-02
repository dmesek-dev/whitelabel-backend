#!/bin/bash

# This script generates Android, iOS, MacOS, and Web app icons from a source image file.
# It creates multiple sizes required for different device densities and platforms.
#
# Requirements:
#   - Imageconvert (convert command)
#   - zip command
#
# The script will:
# 1. Generate Android icons with proper padding for different densities (mdpi to xxxhdpi)
# 2. Generate iOS icons in all required sizes for iPhone and iPad
# 3. Generate MacOS icons in all required sizes
# 4. Generate Web icons in all required sizes
# 5. Create a Contents.json file for iOS and MacOS icon sets
# 6. Package everything into a zip file named assets_<client_name>.zip
# 7. Clean up temporary directories
#
# Expected input:
#   <client_folder> - Source configuration folder
#
# Output:
#   <client_folder>/assets_<client_name>.zip containing:
#     - android_icons/ - Android icon files
#     - ios_icons/ - iOS icon files and Contents.json
#     - macos_icons/ - MacOS icon files and Contents.json
#     - web_icons/ - Web icon files
#     - web_admin_icons/ - Web admin icon files
#     - app_ui_images/ - App UI images for packages/app_ui/assets/images

generate_launcher_background_color() {
    color=`convert $ICON -format '%[hex:p{1,1}]' info:-` && color=${color:0:6}
    color="#$color"

    background=$(cat <<-END
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">$color</color>
</resources>
END
)

    echo "$background" > "$CLIENT_FOLDER/ic_launcher_background.xml"
}

gen_android() {
    MDPI="$ANDROID_DIR/mipmap-mdpi"
    HDPI="$ANDROID_DIR/mipmap-hdpi" 
    XHDPI="$ANDROID_DIR/mipmap-xhdpi"
    XXHDPI="$ANDROID_DIR/mipmap-xxhdpi"
    XXXHDPI="$ANDROID_DIR/mipmap-xxxhdpi"

    mkdir -p $ANDROID_DIR
    mkdir -p $MDPI
    mkdir -p $HDPI
    mkdir -p $XHDPI 
    mkdir -p $XXHDPI
    mkdir -p $XXXHDPI

    FILE_COPY=image_with_padding.png
    cp $ICON $FILE_COPY
    OUTPUT_NAME="ic_launcher.png"

    convert mogrify -path . -bordercolor transparent -border 370 -format png $FILE_COPY
    convert $FILE_COPY -resize $1 $MDPI/$OUTPUT_NAME
    convert $FILE_COPY -resize $2 $HDPI/$OUTPUT_NAME
    convert $FILE_COPY -resize $3 $XHDPI/$OUTPUT_NAME
    convert $FILE_COPY -resize $4 $XXHDPI/$OUTPUT_NAME
    convert $FILE_COPY -resize $5 $XXXHDPI/$OUTPUT_NAME

    rm $FILE_COPY
}

gen_ios() {
    mkdir -p $IOS_DIR
    
    EXT=".png"
    FILE_NAME="icon"

    FILE_20x20=$FILE_NAME"_20"$EXT
    FILE_29x29=$FILE_NAME"_29"$EXT
    FILE_40x40=$FILE_NAME"_40"$EXT
    FILE_40x40_1=$FILE_NAME"_40-1"$EXT
    FILE_40x40_2=$FILE_NAME"_40-2"$EXT
    FILE_60x60=$FILE_NAME"_60"$EXT
    FILE_58x58=$FILE_NAME"_58"$EXT
    FILE_58x58_1=$FILE_NAME"_58-1"$EXT
    FILE_76x76=$FILE_NAME"_76"$EXT
    FILE_87x87=$FILE_NAME"_87"$EXT
    FILE_80x80=$FILE_NAME"_80"$EXT
    FILE_80x80_1=$FILE_NAME"_80-1"$EXT
    FILE_120x120=$FILE_NAME"_120"$EXT
    FILE_120x120_1=$FILE_NAME"_120-1"$EXT
    FILE_152x152=$FILE_NAME"_152"$EXT
    FILE_167x167=$FILE_NAME"_167"$EXT
    FILE_180x180=$FILE_NAME"_180"$EXT
    FILE_1024x1024=$FILE_NAME"_1024"$EXT

    convert $ICON -resize 20x20 $IOS_DIR/$FILE_20x20
    convert $ICON -resize 29x29 $IOS_DIR/$FILE_29x29
    convert $ICON -resize 40x40 $IOS_DIR/$FILE_40x40
    convert $ICON -resize 40x40 $IOS_DIR/$FILE_40x40_1
    convert $ICON -resize 40x40 $IOS_DIR/$FILE_40x40_2
    convert $ICON -resize 60x60 $IOS_DIR/$FILE_60x60
    convert $ICON -resize 58x58 $IOS_DIR/$FILE_58x58
    convert $ICON -resize 58x58 $IOS_DIR/$FILE_58x58_1
    convert $ICON -resize 76x76 $IOS_DIR/$FILE_76x76
    convert $ICON -resize 87x87 $IOS_DIR/$FILE_87x87
    convert $ICON -resize 80x80 $IOS_DIR/$FILE_80x80
    convert $ICON -resize 80x80 $IOS_DIR/$FILE_80x80_1
    convert $ICON -resize 120x120 $IOS_DIR/$FILE_120x120
    convert $ICON -resize 120x120 $IOS_DIR/$FILE_120x120_1
    convert $ICON -resize 152x152 $IOS_DIR/$FILE_152x152
    convert $ICON -resize 167x167 $IOS_DIR/$FILE_167x167
    convert $ICON -resize 180x180 $IOS_DIR/$FILE_180x180
    convert $ICON -resize 1024x1024 $IOS_DIR/$FILE_1024x1024

     # Create Contents.json file.
    cat << EOF > $IOS_DIR/Contents.json
{
  "images" : [
    {
      "size" : "20x20",
      "idiom" : "iphone",
      "filename" : "$FILE_40x40_1",
      "scale" : "2x"
    },
    {
      "size" : "20x20",
      "idiom" : "iphone",
      "filename" : "$FILE_60x60",
      "scale" : "3x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "$FILE_58x58",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "$FILE_87x87",
      "scale" : "3x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "$FILE_80x80",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "$FILE_120x120",
      "scale" : "3x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "$FILE_120x120_1",
      "scale" : "2x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "$FILE_180x180",
      "scale" : "3x"
    },
    {
      "size" : "20x20",
      "idiom" : "ipad",
      "filename" : "$FILE_20x20",
      "scale" : "1x"
    },
    {
      "size" : "20x20",
      "idiom" : "ipad",
      "filename" : "$FILE_40x40",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "$FILE_29x29",
      "scale" : "1x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "$FILE_58x58_1",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "$FILE_40x40_2",
      "scale" : "1x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "$FILE_80x80_1",
      "scale" : "2x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "$FILE_76x76",
      "scale" : "1x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "$FILE_152x152",
      "scale" : "2x"
    },
    {
      "size" : "83.5x83.5",
      "idiom" : "ipad",
      "filename" : "$FILE_167x167",
      "scale" : "2x"
    },
    {
      "size" : "1024x1024",
      "idiom" : "ios-marketing",
      "filename" : "$FILE_1024x1024",
      "scale" : "1x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "ios_icon_set"
  }
} 
EOF

}

gen_macos() {
    mkdir -p $MACOS_DIR
    
    EXT=".png"
    FILE_NAME="icon"

    FILE_16x16=$FILE_NAME"_16"$EXT
    FILE_32x32=$FILE_NAME"_32"$EXT
    FILE_64x64=$FILE_NAME"_64"$EXT
    FILE_128x128=$FILE_NAME"_128"$EXT
    FILE_256x256=$FILE_NAME"_256"$EXT
    FILE_512x512=$FILE_NAME"_512"$EXT
    FILE_1024x1024=$FILE_NAME"_1024"$EXT

    convert $MACOS_ICON -resize 16x16 $MACOS_DIR/$FILE_16x16
    convert $MACOS_ICON -resize 32x32 $MACOS_DIR/$FILE_32x32
    convert $MACOS_ICON -resize 64x64 $MACOS_DIR/$FILE_64x64
    convert $MACOS_ICON -resize 128x128 $MACOS_DIR/$FILE_128x128
    convert $MACOS_ICON -resize 256x256 $MACOS_DIR/$FILE_256x256
    convert $MACOS_ICON -resize 512x512 $MACOS_DIR/$FILE_512x512
    convert $MACOS_ICON -resize 1024x1024 $MACOS_DIR/$FILE_1024x1024

     # Create Contents.json file.
    cat << EOF > $MACOS_DIR/Contents.json
{
  "images" : [
    {
      "size" : "16x16",
      "idiom" : "mac",
      "filename" : "$FILE_16x16",
      "scale" : "1x"
    },
    {
      "size" : "16x16",
      "idiom" : "mac",
      "filename" : "$FILE_32x32",
      "scale" : "2x"
    },
    {
      "size" : "32x32",
      "idiom" : "mac",
      "filename" : "$FILE_32x32",
      "scale" : "1x"
    },
    {
      "size" : "32x32",
      "idiom" : "mac",
      "filename" : "$FILE_64x64",
      "scale" : "2x"
    },
    {
      "size" : "64x64",
      "idiom" : "mac",
      "filename" : "$FILE_64x64",
      "scale" : "1x"
    },
    {
      "size" : "64x64",
      "idiom" : "mac",
      "filename" : "$FILE_128x128",
      "scale" : "2x"
    },
    {
      "size" : "128x128",
      "idiom" : "mac",
      "filename" : "$FILE_128x128",
      "scale" : "1x"
    },
    {
      "size" : "128x128",
      "idiom" : "mac",
      "filename" : "$FILE_256x256",
      "scale" : "2x"
    },
    {
      "size" : "256x256",
      "idiom" : "mac",
      "filename" : "$FILE_256x256",
      "scale" : "1x"
    },
    {
      "size" : "256x256",
      "idiom" : "mac",
      "filename" : "$FILE_512x512",
      "scale" : "2x"
    },
    {
      "size" : "512x512",
      "idiom" : "mac",
      "filename" : "$FILE_512x512",
      "scale" : "1x"
    },
    {
      "size" : "512x512",
      "idiom" : "mac",
      "filename" : "$FILE_1024x1024",
      "scale" : "2x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
} 
EOF

}

gen_web() {
    mkdir -p $WEB_DIR
    mkdir -p $WEB_DIR/icons

    convert $ROUNDED_ICON -resize 256x256! $WEB_DIR/favicon.ico
    convert $ROUNDED_ICON -resize 16x16! $WEB_DIR/favicon.png
    convert $ROUNDED_ICON -resize 192x192! $WEB_DIR/icons/Icon-192.png
    convert $ROUNDED_ICON -resize 152x152! $WEB_DIR/icons/Icon-512.png
    convert $ROUNDED_ICON -resize 192x192! $WEB_DIR/icons/Icon-maskable-192.png
    convert $ROUNDED_ICON -resize 152x152! $WEB_DIR/icons/Icon-maskable-512.png
}

gen_web_admin() {
    mkdir -p $WEB_ADMIN_DIR
    mkdir -p $WEB_ADMIN_DIR/icons

    convert $WEB_ADMIN_ICON -resize 256x256! $WEB_ADMIN_DIR/favicon.ico
    convert $WEB_ADMIN_ICON -resize 16x16! $WEB_ADMIN_DIR/favicon.png
    convert $WEB_ADMIN_ICON -resize 192x192! $WEB_ADMIN_DIR/icons/Icon-192.png
    convert $WEB_ADMIN_ICON -resize 152x152! $WEB_ADMIN_DIR/icons/Icon-512.png
    convert $WEB_ADMIN_ICON -resize 192x192! $WEB_ADMIN_DIR/icons/Icon-maskable-192.png
    convert $WEB_ADMIN_ICON -resize 152x152! $WEB_ADMIN_DIR/icons/Icon-maskable-512.png
}

generate_app_ui_images() {
    local padding_top_bottom=35
    local padding_left_right=25
    local splash_logo_light="splash_logo_light.png"
    local splash_logo_dark="splash_logo_dark.png"
    local admin_splash_logo_light="admin_splash_logo_light.png"
    local admin_splash_logo_dark="admin_splash_logo_dark.png"
    local padded_image_light="padded_image_light.png"
    local padded_image_dark="padded_image_dark.png"
    local padded_admin_image_light="padded_admin_image_light.png"
    local padded_admin_image_dark="padded_admin_image_dark.png"

    # Add padding to the MAIN_APP_SPLASH_LOGO_LIGHT
    convert $MAIN_APP_SPLASH_LOGO_LIGHT -bordercolor transparent -border ${padding_left_right}x${padding_top_bottom} -resize 1371x513 $padded_image_light
    # Save the padded image as splash_logo_light.png in APP_UI_IMAGES_DIR
    mv $padded_image_light $APP_UI_IMAGES_DIR/$splash_logo_light

    # Add padding to the MAIN_APP_SPLASH_LOGO_DARK
    convert $MAIN_APP_SPLASH_LOGO_DARK -bordercolor transparent -border ${padding_left_right}x${padding_top_bottom} -resize 1371x513 $padded_image_dark
    # Save the padded image as splash_logo_dark.png in APP_UI_IMAGES_DIR
    mv $padded_image_dark $APP_UI_IMAGES_DIR/$splash_logo_dark

    # Add padding to the ADMIN_APP_SPLASH_LOGO_LIGHT
    convert $ADMIN_APP_SPLASH_LOGO_LIGHT -bordercolor transparent -border ${padding_left_right}x${padding_top_bottom} -resize 1384x512 $padded_admin_image_light
    # Save the padded image as admin_splash_logo_light.png in APP_UI_IMAGES_DIR
    mv $padded_admin_image_light $APP_UI_IMAGES_DIR/$admin_splash_logo_light

    # Add padding to the ADMIN_APP_SPLASH_LOGO_DARK
    convert $ADMIN_APP_SPLASH_LOGO_DARK -bordercolor transparent -border ${padding_left_right}x${padding_top_bottom} -resize 1384x512 $padded_admin_image_dark
    # Save the padded image as admin_splash_logo_dark.png in APP_UI_IMAGES_DIR
    mv $padded_admin_image_dark $APP_UI_IMAGES_DIR/$admin_splash_logo_dark
}

while getopts "c:wm" OPTION
do
    case $OPTION in
    c)
        CLIENT_FOLDER=$OPTARG
        ;;
    esac
done

aws s3 cp --recursive s3://demo-app-clients22/$CLIENT_FOLDER $CLIENT_FOLDER

CLIENT_NAME=$(basename $CLIENT_FOLDER)
ICON="$CLIENT_FOLDER/icon.png"
ROUNDED_ICON="$CLIENT_FOLDER/app_ui_images/logo_png2.png"
MACOS_ICON="$CLIENT_FOLDER/macos_icon.png"
WEB_ADMIN_ICON="$CLIENT_FOLDER/web_admin_icon.png"
ANDROID_DIR="$CLIENT_FOLDER/android_icons"
IOS_DIR="$CLIENT_FOLDER/ios_icons"
MACOS_DIR="$CLIENT_FOLDER/macos_icons"
WEB_DIR="$CLIENT_FOLDER/web_icons"
WEB_ADMIN_DIR="$CLIENT_FOLDER/web_admin_icons"
APP_UI_IMAGES_DIR="$CLIENT_FOLDER/app_ui_images"
MAIN_APP_SPLASH_LOGO_LIGHT="$APP_UI_IMAGES_DIR/logo_light.png"
MAIN_APP_SPLASH_LOGO_DARK="$APP_UI_IMAGES_DIR/logo_dark.png"
ADMIN_APP_SPLASH_LOGO_LIGHT="$APP_UI_IMAGES_DIR/admin_logo_light.png"
ADMIN_APP_SPLASH_LOGO_DARK="$APP_UI_IMAGES_DIR/admin_logo_dark.png"
ASSETS_ZIP_NAME="assets.zip"

echo "Generating assets zip for $CLIENT_NAME"
generate_app_ui_images
gen_android 108x108 162x162 216x216 324x324 432x432
gen_ios
gen_macos
gen_web
gen_web_admin
generate_launcher_background_color
cd $CLIENT_FOLDER
zip -r $ASSETS_ZIP_NAME android_icons ios_icons macos_icons web_icons web_admin_icons ic_launcher_background.xml app_ui_images
rm -rf android_icons
rm -rf ios_icons
rm -rf macos_icons
rm -rf web_icons
rm -rf web_admin_icons
rm -rf ic_launcher_background.xml
rm -f app_ui_images/splash_logo_light.png
rm -f app_ui_images/splash_logo_dark.png
rm -f app_ui_images/admin_splash_logo_light.png
rm -f app_ui_images/admin_splash_logo_dark.png

echo "Assets zip for $CLIENT_NAME generated"

aws s3api put-object \
        --bucket $S3_BUCKET_NAME \
        --key $CLIENT_NAME/$ASSETS_ZIP_NAME \
        --body $CLIENT_FOLDER/$ASSETS_ZIP_NAME
