CLDR_XML='tmp/cldr-core'
CLDR_PSTORE='data/cldr'

def parse_cldr(locale)
  if File.file? "#{CLDR_PSTORE}/#{locale.gsub /_/, '-'}.pstore"
    return PStore.new("#{CLDR_PSTORE}/#{locale.gsub /_/, '-'}.pstore")
  end
  
  puts "Parsing #{locale}"
  xml = REXML::Document.new(open("#{CLDR_XML}/main/#{locale}.xml"))
        
  lang = xml.elements['/ldml/identity/language'].attributes['type']
  terr = xml.elements['/ldml/identity/territory']
  unless terr.nil?
    terr = terr.attributes['type']
  end
  script = xml.elements['/ldml/identity/script']
  unless script.nil?
    script = script.attributes['type']
  end
  
  if terr.nil?
    if script.nil?
      cldr = PStore.new("#{CLDR_PSTORE}/#{lang}.pstore")
      parent = nil
    else
      cldr = PStore.new("#{CLDR_PSTORE}/#{lang}-#{script}.pstore")
      parent = nil
    end
  else
    if script.nil?
      cldr = PStore.new("#{CLDR_PSTORE}/#{lang}-#{terr}.pstore")
      parent = parse_cldr(lang)
    else
      cldr = PStore.new("#{CLDR_PSTORE}/#{lang}-#{script}-#{terr}.pstore")
      parent = parse_cldr("#{lang}_#{script}")
    end
  end

  
  if xml.elements['/ldml/alias/'].nil?
    cldr.transaction do
      cldr[:numeric] = {}
      
    end
  else
    alias_element = xml.elements['/ldml/alias/']
    alias_cldr = parse_cldr(alias_element.attributes['source'])
    alias_cldr.transaction(true) do
      cldr.transaction do
        alias_cldr.roots.each do |root|
          cldr[root] = alias_cldr[root]
        end
      end
    end
  end

  return cldr
end

namespace :cldr do
  desc "Force download and unzip of CLDR files"
  task :force_download do
    require 'net/http'
    require 'fileutils'
    
    FileUtils.mkdir_p CLDR_XML
    Net::HTTP.start('unicode.org') do |http|
      resp = http.get('/Public/cldr/1.6.1/core.zip')
      open("#{pwd}/tmp/cldr-core-1.6.1.zip", 'wb') do |file|
        file.write(resp.body)
      end
    end

    sh %{unzip -qo tmp/cldr-core-1.6.1.zip -d #{CLDR_XML}}
  end

  desc "Download and unzip CLDR files"
  task :download

  
  unless File.file?("#{pwd}/tmp/cldr-core-1.6.1.zip")
    task :download => [:force_download]
  end

  desc "Forced processing of CLDR data"
  task :force_process => [:download] do
    require 'rexml/document'
    require 'pstore'
    require 'fileutils'
    
    if File.directory? CLDR_PSTORE
      FileUtils.rm_r CLDR_PSTORE
    end
    FileUtils.mkdir_p CLDR_PSTORE

    Dir["#{CLDR_XML}/main/*.xml"].each do |file|
      parse_cldr(File.basename(file, '.xml'))
    end
  end

  desc "Processing of CLDR data"
  task :process

  unless File.directory? "#{pwd}/data/cldr"
    task :process => [:force_process] 
  end
end

