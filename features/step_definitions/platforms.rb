# Encoding: UTF-8

Then(/^the platforms maps the following items:$/) do |platforms|
  puts platforms.hashes.each do |hsh|
    expect(@project.platforms.send(hsh['Nickname'])).to eq(hsh['FullName'])
    expect(@project.platforms[hsh['Nickname']]).to eq(hsh['FullName'])
  end
end
