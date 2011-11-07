xml.instruct!
xml.node do
  xml.name name
  xml.full_name full_name

  xml.parent do
    xml.name parent.name
    xml.full_name parent.full_name
  end

  xml.children do
    children.values.each do |child|
      xml.node do 
        xml.name child.name
        xml.full_name child.full_name
      end
    end
  end

  eval_attrs.each_pair do |k,v|
    if v.class == Lipa::Node
      xml.__send__(k) do
        xml.node do
          xml.name v.name
          xml.full_name v.full_name
        end
      end
    else
      xml.__send__(k,v)
    end
  end
end
