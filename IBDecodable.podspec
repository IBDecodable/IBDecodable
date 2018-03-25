Pod::Spec.new do |s|
  s.name           = 'IBDecodable'
  s.version        = '0.0.1'
  s.summary        = 'A linter tool for Interface Builder.'
  s.homepage       = 'https://github.com/IBDecodable/IBDecodable'
  s.license        = { :type => 'MIT', :file => 'LICENSE' }
  s.author         = { 'Steven Deutsch' => 'stevensdeutsch@yahoo.com' }
  s.source         = { :git => "https://github.com/IBDecodable/IBDecodable.git", :tag => s.version }
  s.preserve_paths = 'bin/*'
end
