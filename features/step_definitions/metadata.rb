# Encoding: UTF-8

Then(/^the metadata (has|doesn't have) a(n)? (\w+) attribute$/) do |has, _, a|
  case has
  when 'has'
    regex = case a
            when 'url'
              %r{^https://opscode-omnibus-packages\.s3\.amazonaws\.com.*$}
            when 'filename'
              /^[A-Za-z0-9_\.\-\+]+\.(rpm|deb|pkg|msi)$/
            when 'md5'
              /^\w{32}$/
            when 'sha256'
              /^\w{64}$/
            end
    expect(@project.metadata.send(a)).to match(regex)
  else
    expect(@project.metadata.send(a)).to eq(nil)
  end
end
