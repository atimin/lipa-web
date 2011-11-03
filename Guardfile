guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { "spec" }
  watch(%r{^lib/(.+)\.erb$}) { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch('spec/fixtures/*.*')  { "spec" }
end
