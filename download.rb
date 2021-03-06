#!/usr/bin/env ruby
#Copyright 2015 Nilanjan Roy (nilanjan1.roy@gmail.com)

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

require 'trollop'
require "celluloid/pmap"
require "timeit"

class FileDownloader

  def initialize(input_dir:, output_dir:, matching_string: "songid")
    @input_dir = input_dir
    @output_dir = output_dir
    @matching_string = matching_string
    create_dir(@output_dir)
  end

  def create_title_dir(lines)
    lines.each do |line|
      if !line.match("title").nil?
        _download_dir = line.gsub("<title>","").gsub("</title>","").split(",")[0].split("-")[-1].strip.gsub(" ","_")
        title_dir = File.join(@output_dir,_download_dir)
        create_dir(title_dir)
        return title_dir
      end
    end
  end

  def create_dir(dir)
    Dir.mkdir(dir) unless File.exists?(dir)
  end

  def get_input_files(dir)
    Dir.glob("#{dir}/*.html").select{ |e| File.file? e }
  end

  def line_finder(lines)
    l = []
    lines.each do |line|
      if !line.match(@matching_string).nil?
        start_line = lines.index(line)
        ending_line = start_line + 1
        l.push(lines[start_line..ending_line].join.strip.gsub("\n", ' ').gsub("\t",' ').squeeze(' '))
      end
    end
    return l
  end

  def create_files_url_list(lines)
    h = []
    lines.each do |line|
      l = line.gsub("</a></td>","").gsub("<a","").split(">")
      file_name = l[1]
      if !file_name.match("<td").nil?
        file_name = file_name.split("<td")[0].strip
      end
      url = l[0].gsub("href=","").gsub('"',"").strip
      h.push({"name" => file_name, "url" => url})
    end
    return h
  end

  def download(files,download_dir)
    files.pmap do |file_metadata|
      puts "Downloading #{file_metadata["name"]} from #{file_metadata["url"]}"
      `wget -O "#{download_dir}/#{file_metadata["name"]}.mp3" "#{file_metadata["url"]}"`
    end
  end

  def main()
    @downloaded = []
    begin
      timer = Timeit.ti do
        input_files = get_input_files(@input_dir)
        input_files.pmap do |input_file|
          f = open(input_file,"r")
          lines = f.readlines()
          title_dir = create_title_dir(lines)
          extracted_lines = line_finder(lines)
          if !extracted_lines.empty?
            files = create_files_url_list(extracted_lines)
            download(files,title_dir)
            @downloaded.push(File.basename(title_dir))
          end
        end
      end
    rescue => e
      puts "ERROR encountered: #{e.message}"
    end
    puts "Downloaded following  - \n#{@downloaded.join("\n")}"
    puts "Download completed in #{timer.total_duration}"
  end
end

if __FILE__ == $0

  opts = Trollop::options do
    opt :input_dir, 'Input Directory containing the html files', :type => :string, :default => nil
    opt :output_dir, 'Output Directory to store the downloaded files', :type => :string, :default => nil
    opt :matching_string, 'String to find the file URL', :type => :string, :default => 'songid'
  end

  Trollop::die :input_dir, 'Provide the input directory' unless opts[:input_dir]
  Trollop::die :output_dir, 'Provide the output directory' unless opts[:output_dir]
  Trollop::die :matching_string, 'Provide the matching_string' unless opts[:matching_string]

  FileDownloader.new(input_dir: opts[:input_dir], output_dir: opts[:output_dir],
                     matching_string: opts[:matching_string]).main

end
