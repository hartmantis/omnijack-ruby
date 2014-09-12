# Encoding: UTF-8

Given(/^a(n)? ([\w ]+) ([0-9\.]+) node$/) do |_, platform, version|
  node = { platform: platform.split.join('_').downcase,
           platform_version: version,
           kernel: { machine: 'x86_64' } }
  allow_any_instance_of(Omnijack::Metadata).to receive(:node).and_return(node)
end

Given(/^no special arguments$/) do
  @args = {}
end

Given(/^nightlies enabled$/) do
  @args = { nightlies: true }
end

When(/^I create a(n)? (\w+) project$/) do |_, project|
  @project = Omnijack::Project.const_get(project).new(@args)
end
