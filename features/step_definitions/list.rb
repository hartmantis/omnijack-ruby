# Encoding: UTF-8

Then(/^the list has a section for ([\w ]+) ([0-9\.]+) x86_64$/) do |p, v|
  platform = p.split.join('_').downcase.to_sym
  version = v.to_sym
  [
    @project.list.send(platform)[version][:x86_64],
    @project.list[platform][version][:x86_64]
  ].each do |i|
    expect(i).to be_an_instance_of(Hash)
  end
end
