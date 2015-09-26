#!/usr/bin/ruby
f = open("song.html","r")
lines = f.readlines()
download_dir = "downloads"
def line_finder(lines)
  l = []
  lines.each do |line|
    if !line.match("songid").nil?
      start_line = lines.index(line)
      ending_line = start_line + 1
      l.push(lines[start_line..ending_line].join.strip.gsub("\n", ' ').gsub("\t",' ').squeeze(' '))
    end
  end
  return l
end

def create_songs_url_list(lines)
  h = []
  lines.each do |line|
    #puts line
    l = line.gsub("</a></td>","").gsub("<a","").split(">")
    song_name = l[1]
    if !song_name.match("<td").nil?
      song_name = song_name.split("<td")[0].strip
    end
    url = l[0].gsub("href=","").gsub('"',"").strip
    h.push({"name" => song_name, "url" => url})
  end
  return h
end

def download(songs,download_dir)
  songs.each do |song_metadata|
    puts "Downloading #{song_metadata["name"]} from #{song_metadata["url"]}"
    `wget -O "#{download_dir}/#{song_metadata["name"]}.mp3" "#{song_metadata["url"]}"`
  end
end


lines = line_finder(lines)
songs = create_songs_url_list(lines)
download(songs,download_dir)
