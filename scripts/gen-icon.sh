convert="/ImageMagick-6.8.3/bin/convert"
ios=iOS
ios2x=iOS_2x
android=../love-android-sdl2/app/src/main/res
icon=design/icon.png

#ios
if [ "$1" == "ios" ]; then
$convert $icon -resize 29x29 $ios/app_icon_29.png
$convert $icon -resize 40x40 $ios/app_icon_40.png
$convert $icon -resize 50x50 $ios/app_icon_50.png
$convert $icon -resize 57x57 $ios/app_icon_57.png
$convert $icon -resize 60x60 $ios/app_icon_60.png
$convert $icon -resize 72x72 $ios/app_icon_72.png
$convert $icon -resize 76x76 $ios/app_icon_76.png

$convert $icon -resize 58x58 $ios2x/app_icon_29_x2.png
$convert $icon -resize 80x80 $ios2x/app_icon_40_x2.png
$convert $icon -resize 100x100 $ios2x/app_icon_50_x2.png
$convert $icon -resize 114x114 $ios2x/app_icon_57_x2.png
$convert $icon -resize 120x120 $ios2x/app_icon_60_x2.png
$convert $icon -resize 144x144 $ios2x/app_icon_72_x2.png
$convert $icon -resize 152x152 $ios2x/app_icon_76_x2.png
elif [ "$1" == "android" ]; then
#android 
$convert $icon -resize 32x32 $android/drawable-ldpi/love.png
$convert $icon -resize 48x48 $android/drawable-mdpi/love.png
$convert $icon -resize 72x72 $android/drawable-hdpi/love.png
$convert $icon -resize 96x96 $android/drawable-xhdpi/love.png
$convert $icon -resize 114x114 $android/drawable-xxhdpi/love.png
$convert $icon -resize 192x192 $android/drawable-xxxhdpi/love.png
else 
    echo "Usage: icons ios|android"
fi