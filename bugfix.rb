#!/usr/bin/env ruby

fns = Hash.new(0)
lines = `git log --oneline | grep -E "\\[bugfix\\]" | cut -d ' ' -f 1`.strip
lines.split("\n").each do |l|
  `git diff --numstat #{l} '#{l}~1'`.split("\n").each do |diff_info|
    ni, nd, _file = diff_info.split(/\s+/)
    file = _file.strip
    
    fns[file] += ni.to_i + nd.to_i
  end
end

puts(fns.sort_by do |item|
  -item.last
end.map do |name, n|
  "%d %s" % [n, name]
end.join("\n"))
