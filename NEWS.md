2011-11-10 Release 0.2.0
---------------------------
- Added serve static files
    
  ```Ruby
    root :srv do
      static_folder File.dirname(__FILE__) + "/public"
    end
  ```

- Added support XML format
- Added custom html response  
  
  ```Ruby
    node :page_1 do
      say "Hello"
      html { <h1>#{say}</h1> }
    end
  ```

2011-11-05 Release 0.1.1
---------------------------
Resolved problem with dependency json and ruby version (support only >=1.9.2)

2011-11-05 Release 0.1.0
----------------------------
Initial release
