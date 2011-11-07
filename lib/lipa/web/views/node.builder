instruct!
node do
  name node.name
  full_name node.full_name

  parent do
    name node.parent.name
    full_name node.parent.full_name
  end

  children do
    node.children.values.each do |child|
      node do 
        name child.name
        full_name child.full_name
      end
    end
  end

  node.eval_attrs.each_pair do |k,v|
    if v.class.to_s == "Lipa::Node"
      __send__(k) do
        node do
          name v.name
          full_name v.full_name
        end
      end
    else
      __send__(k,v)
    end
  end
end
