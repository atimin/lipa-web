LipaWeb  [![Build Status](https://secure.travis-ci.org/flipback/lipa-web.png)](http://travis-ci.org/flipback/lipa-web)
=======================================================
LipaWeb - micro web-framework based on [Lipa](http://lipa.flipbacl.new) for Web access to lipa-structures

Features
----------------------------------------------------
- Based on Rack and Lipa
- Support HTML,JSON and text format response
- Support ERB templates with layouts

Example
----------------------------------------------------

    require 'lipa-web'
    srv = root :universe do 
      kind :planet_system do
        num_planet run{
          count = 0
          children.values.each do |planet|
            count += 1 if planet.kind == :planet
          end
          count
        }
      end

      kind :planet do 
        has_live false
        has_water false
        number 0
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

    srv.run! #Run server
    # GET http://127.0.0.1:9292

Installation
-----------------------------------------------------
`gem install lipa-web`

Reference
----------------------------------
Home page: https://github.com/flipback/lipa-web
Lipa home page: http://lipa.flipback.net
