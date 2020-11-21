Pod::Spec.new do |spec|
  spec.name         = 'Requester'
  spec.version      = '0.0.2'
  spec.authors      = { 
    'Pavlo Dumiak' => 'pavlo.dumiak@gmail.com'
  }
  spec.license      = { 
    :type => 'MIT',
    :file => 'LICENSE' 
  }
  spec.homepage     = 'https://github.com/pavserg/Requester'
  spec.source       = { 
    :git => 'https://github.com/pavserg/Requester.git', 
    :branch => 'master',
    :tag => spec.version.to_s 
  }
  spec.summary      = 'Elegant request manager'
  spec.source_files = '**/*.swift', '*.swift'
  spec.swift_versions = '5.1'
  spec.ios.deployment_target = '11.0'
end