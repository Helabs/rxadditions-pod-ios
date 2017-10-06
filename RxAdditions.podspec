#
# Be sure to run `pod lib lint RxAdditions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'RxAdditions'
    s.version          = '0.1.0'
    s.summary          = 'Helper classes for RxSwift.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
    s.description      = <<-DESC
    A collection of classes and helpers used with RxSwift
                         DESC
  
    s.homepage         = 'https://github.com/helabs/coordinator-ios-pod'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Marcilio Júnior' => 'marciliojrs@gmail.com' }
    s.source           = { :git => 'https://github.com/helabs/rxadditions-pod-ios.git', :tag => s.version.to_s }
    s.default_subspec  = 'Core'
    s.ios.deployment_target = '8.0'
  
    s.subspec "Core" do |ss|
      ss.source_files = 'Classes/RxAdditions/'  
      ss.dependency 'RxSwift', '~> 3.6'
      ss.dependency 'RxCocoa', '~> 3.6'
      ss.framework  = 'UIKit'
      ss.framework  = 'Foundation'
    end    

    s.subspec "PINRemoteImage" do |ss|
      ss.source_files = 'Classes/PINRemoteImage/'
      ss.dependency 'RxAdditions/Core'
      ss.dependency 'PINRemoteImage', '~> 3.0.0-beta.12'
    end
  end