# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def common_pods
    pod 'Moya/RxSwift', '~> 10.0'
    pod 'Result'
end

target 'RevolutConverter' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  common_pods

  target 'RevolutConverterTests' do
    inherit! :search_paths
    common_pods
  end

end
