Pod::Spec.new do |s|
  s.name         = "CoreDataMate"
  s.version      = "0.1.0"
  s.summary      = "CoreDataMate is a lightweight CoreData assistant. It gives you all of the control of CoreData, but helps you manage it."
  s.description  = <<-DESC
                    CoreDataMate is a lightweight CoreData assistant. It gives you all of the control of CoreData, but helps you manage it.
                   DESC
  s.homepage     = "http://EXAMPLE/NAME"
  s.license      = 'MIT'
  s.author       = { "Todd Grooms" => "todd.grooms@gmail.com" }
  s.source       = { :git => "http://EXAMPLE/NAME.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
end
