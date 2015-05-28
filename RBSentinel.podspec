Pod::Spec.new do |s|

  s.name            = 'RBSentinel'
  s.version         = '0.1.3'
  s.license         = 'MIT'
  s.platform        = :ios, '8.2'

  s.summary         = 'RBSentinel improves communication gap between the applewatch and the parent application.'
  s.homepage        = 'https://github.com/RoshanNindrai/RBSentinel'
  s.author          = { 'Roshan Balaji' => 'roshan.nindrai@gmail.com'}
  s.source          = { :git => 'https://github.com/RoshanNindrai/RBSentinel.git', :tag => s.version.to_s }

  s.source_files    = 'RBSentinel/RBSentinel.{h,m}'

  s.requires_arc    = true
end
