
Pod::Spec.new do |s|

  s.name         = "LXF_Tools"
  s.version      = "0.0.5"
  s.summary      = "LXF的工具类"
  s.description  = <<-DESC
			LXF的自用工具类
                   DESC

  s.homepage     = "https://github.com/jiminyL/LXFToolkit"
  s.license = "Copyright (c) 2019年 JiminyL. All rights reserved."

  s.author             = { "jiminyL" => "jaewon_89@me.com" }
  s.source       = { :git => "https://github.com/jiminyL/LXFToolkit", :tag => "v0.0.5" }

  s.source_files  = "LXF_Tools/**/*"

end
