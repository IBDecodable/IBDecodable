Pod::Spec.new do |s|
  s.name           = 'IBDecodable'
  s.version        = '0.5.0'
  s.summary        = 'A tool to translate xib and storyboard XML into Swift models.'
  s.homepage       = 'https://github.com/IBDecodable/IBDecodable'
  s.license        = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author         = { 'Steven Deutsch' => 'stevensdeutsch@yahoo.com' }
  s.source         = { :git => "https://github.com/IBDecodable/IBDecodable.git", :tag => s.version }
  s.source_files   = 'Sources/*.swift'
  s.platform       = :osx, '10.9'
  s.dependency     "SWXMLHash", "~> 6.0.0"
end
