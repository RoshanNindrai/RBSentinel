Pod::Spec.new do |s|

  s.name            = 'RBSentinel'
  s.version         = '0.1.0'
  s.license         = 'MIT'
  s.platform        = :ios, '8.0'

  s.summary         = 'RBSentinel helps is filling the communication gap between the applewatch and the parent application. It opens up a REST based interface to handle information needed by the watchapp.'
  s.homepage        = 'https://github.com/RoshanNindrai/RBSentinel'
  s.author          = { 'Roshan Balaji' => 'roshan.nindrai@gmail.com'}
  s.source          = { :git => 'https://github.com/RoshanNindrai/RBSentinel.git', :tag => s.version.to_s }

  s.source_files    = 'RBSentinel/RBSentinel.{h,m}'

  s.requires_arc    = true
end
