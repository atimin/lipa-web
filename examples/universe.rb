$:.unshift File.join(File.dirname(__FILE__),'../lib')
require 'lipa/web'

un = root :universe do 
  views File.join(File.dirname(__FILE__), "views")
  layout "base.html.erb"

  kind :planet_system do
    num_planet run{
      count = 0
      children.values.each do |planet|
        count += 1 if planet.kind == :planet
      end
      count
    }

    html erb("planet_system.html.erb")
  end

  kind :planet do 
    has_live false
    has_water false
    number 0

    html erb("planet.html.erb")
  end

  planet_system :sun_system do 
    planet :mercury do 
      number 1
      radius 46_001_210 
    end

    planet :venus do 
      number 2
      radius 107_476_259
    end

    planet :earth do 
      number 3
      radius 147_098_074
      has_live true
      has_water true

      node :moon, :radius => 363_104
    end
  end
end

un.run!
