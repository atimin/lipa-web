LipaWeb  [![Build Status](https://secure.travis-ci.org/flipback/lipa-web.png)](http://travis-ci.org/flipback/lipa-web)
=======================================================
LipaWeb - micro webframework based on [Lipa](http://lipa.flipback.new) for web access to treelike structures

Features
----------------------------------------------------
- Based on Rack and Lipa
- HTML,JSON, XML and text formats of response
- ERB templates with layouts
- Static files


Installation
----------------------------------------------------
`gem install lipa-web`

Example
----------------------------------------------------

    require 'lipa-web'
    app = root :app do 
      node :group do
        node :node_1 do
          msg "Hello World!"
        end
      end
    end

    app.run! #Run server
    # GET http://127.0.0.1:9292/group/node

###Server options

Server has default options:

  1. host '127.0.0.1'
  2. port 9292
  3. server :webrik - name of server(see servers  of Rack)
  4. debug false
  5. views "./views" - dir for templates
  6. static_folder "./public" - dir for static files

You can set your options in root of description

    root :app do
      static_folder "path/to/dir/with/static/files"
      port 80
      server :thin
    end

###Formats

You can get representation of data in HTML, JSON or XML formats:

    GET http://127.0.0.1:9292/group/node #=> render default HTML template for node
    GET http://127.0.0.1:9292/group/node.json 
    #=> 
    { 
      "name":"node", 
      "full_name":"/group/node",
      "parent": {
        "name":"group",
        "full_name":"/group",
      }
      "msg":"Hello World!"
    }

    GET http://127.0.0.1:9292/group/node.xml
    #=> 
    <node>
      <name>node</node>
      <full_name>/group/node</full_name>
      <parent>
        <name>group</node>
        <full_name>/group</full_name>
      </parent>
      <msg>Hello World!</msg>
    </node>

### Templates 

Now LipaWeb is supporting only ERB templates for rendering in HTML format and Builder for XML. Use this syntax for linking templates with node:

    node :node_1 do
      html erb("path/to/file/in/views/dir")     #HTML format
      xml builder("path/to/file/in/views/dir")  #XML format
    end

Also you can use layout. For it:

    root :app do
      layout  "path/to/file/views/dir"
    end

### Custom responses

LipaWeb provide custom responses in block:

    node :node_1 do
      msg "Hello"

      html { "<h1>#{msg}</h1" }
      json { |json| json[:msg] = msg }
      xml  { |xml| xml.msg msg }
    end

All template binding with node. For example:

    #*.html.erb:
    <h1><%= name %></h1>
    <p><%= parent.name %></h1>

    #*builder
    xml.node do
      xml.name name
      xml.parent parent.name
    end

### Lipa

LipaWeb is extension of Lipa and inherit its features:

    root :app do
      kind :greater do
        html { <h1>Hello, #{name.to_s.capitalize}!</h1> }
      end

      greater :ann
      greater :aleksey
      #....
    end

Reference
----------------------------------
Home page: https://github.com/flipback/lipa-web

Lipa home page: http://lipa.flipback.net 
