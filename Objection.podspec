Pod::Spec.new do |s|
  s.name         = 'Objection'
  s.version      = '0.9'
  s.summary      = 'A lightweight dependency injection framework for Objective-C.'
  s.author       = { 'Justin DeWind' => 'dewind@atomicobject.com' }
  s.source       = { :git => 'https://github.com/atomicobject/objection.git', :tag => '0.9' }
  s.xcconfig     = { 'OTHER_LDFLAGS' => '-ObjC -all_load' }
  s.homepage     = 'http://www.objection-framework.org'
  s.source_files = 'Source'
end
