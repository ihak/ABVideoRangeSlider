#
# Be sure to run `pod lib lint ABVideoRangeSlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ABVideoRangeSlider'
  s.version          = '0.2.0'
  s.summary          = 'A simple range slider for trimming videos originally written in Swift 3 and updated to Swift 4.2. Includes a Progress Indicator.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Display thumbnails and a slider for trimming videos in iOS. Includes a Progress Indicator'

  s.homepage         = 'https://github.com/ihak/ABVideoRangeSlider'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Oscar J. Irun' => 'oscarjiv91@gmail.com', 'Hassan Ahmed Khan' => 'hassandotahmed@gmail.com' }
  s.source           = { :git => 'https://github.com/ihak/ABVideoRangeSlider.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hassandotahmed'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ABVideoRangeSlider/Classes/**/*', 'ABVideoRangeSlider/Assets/*'

  s.resource_bundles = {
    'ABVideoRangeSlider' => ['ABVideoRangeSlider/Assets/*.png']
  }

end
