# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'aloxide-sdk-swift' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for aloxide-sdk-swift
#  pod "PromiseKit", "~> 6.0"

  # Pods for Aloxide
  pod 'ICONKit', '~> 0.3.1'
   pod "EosioSwift", "~> 0.4.0" # pod for this library
  # Providers for EOSIO SDK for Swift
  pod "EosioSwiftAbieosSerializationProvider", "~> 0.4.0" # serialization provider
  pod "EosioSwiftSoftkeySignatureProvider", "~> 0.4.0" # experimental signature provider for development only
  target 'aloxide-sdk-swiftTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'aloxide-sdk-swiftUITests' do
    # Pods for testing
  end

end
