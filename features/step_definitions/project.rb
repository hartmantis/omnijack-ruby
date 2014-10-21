# Encoding: UTF-8

Given(/^a(n)? ([\w ]+) ([0-9\.]+) node$/) do |_, platform, version|
  @args = { platform: platform.split.join('_').downcase,
            platform_version: version,
            machine_arch: 'x86_64' }
end

Given(/^no special arguments$/) do
end

Given(/^nightlies enabled$/) do
  @args.merge!(nightlies: true)
end

When(/^I create a(n)? (\w+) project$/) do |_, project|
  @project = Omnijack::Project.const_get(project).new(@args)
end
