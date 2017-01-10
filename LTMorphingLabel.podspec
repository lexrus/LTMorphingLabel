Pod::Spec.new do |s|

  s.name         = "LTMorphingLabel"
  s.version      = "0.4.0"
  s.summary      = "Graceful morphing effects for UILabel written in Swift."
  s.description  = <<-DESC
                   A morphing UILabel subclass written in Swift.
                   The .Scale effect mimicked Apple's QuickType animation of iOS
                   8 in WWDC 2014. New morphing effects are available as
                   Swift extensions.
                   DESC
  s.homepage     = "https://github.com/lexrus/LTMorphingLabel"
  s.screenshots  = "https://cloud.githubusercontent.com/assets/219689/3491822/96bf5de6-059d-11e4-9826-a6f82025d1af.gif",
                   "https://cloud.githubusercontent.com/assets/219689/3491838/ffc5aff2-059d-11e4-970c-6e2d7664785a.gif",
                   "https://cloud.githubusercontent.com/assets/219689/3491840/173c2238-059e-11e4-9b33-dcd21edae9e2.gif",
                   "https://cloud.githubusercontent.com/assets/219689/3491845/29bb0f8c-059e-11e4-9ef8-de56bec1baba.gif",
                   "https://cloud.githubusercontent.com/assets/219689/3508789/31e9fafe-0690-11e4-9a76-ba3ef45eb53a.gif",
                   "https://cloud.githubusercontent.com/assets/219689/3594949/815cd3e8-0caa-11e4-9738-278a9c959478.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Lex Tang" => "lexrus@gmail.com" }
  s.social_media_url   = "https://twitter.com/lexrus"
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.source       = {
                    :git => "https://github.com/lexrus/LTMorphingLabel.git",
                    :tag => s.version
                   }
  s.source_files = "LTMorphingLabel/*.{h,swift}"
  s.resources    = "LTMorphingLabel/Particles/*.png"
  s.frameworks   = "UIKit", "Foundation", "QuartzCore"
  s.requires_arc = true

end
