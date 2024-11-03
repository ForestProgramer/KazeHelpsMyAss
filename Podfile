#source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '16.0'
use_frameworks!

target 'AudioGuide' do
    pod 'Starscream'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'NoticeObserveKit'
    pod 'SwiftMessages'
    pod 'FlagKit'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'Google-Maps-iOS-Utils'
    pod 'FBSDKLoginKit'
    pod 'GoogleSignIn'
    pod 'SkeletonView'
    pod 'SDWebImage'
    pod 'InstantSearchVoiceOverlay'
    pod 'UIScrollView-InfiniteScroll'
    pod 'FloatingPanel'
    pod 'Cosmos'
    post_install do |installer|
        installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
                end
            end
        end
    end
end

