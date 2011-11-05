NEXT Release 0.2.0
---------------------------
- Added custom html response  
  
  ```Ruby
    node :page_1 do
      hello = "<h1>Hello!</h1>
      html { |h| 
        h[:status] = 200
        h[:body] = hello
      }
    end
  ```

2011-11-05 Release 0.1.1
---------------------------
Resolved problem with dependency json and ruby version (support only >=1.9.2)

2011-11-05 Release 0.1.0
----------------------------
Initial release
