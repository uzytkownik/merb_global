CLDR_XML='tmp/cldr-core'
CLDR_PSTORE='data/cldr'

def parse_cldr(locale, cldr_hash)
  if not cldr_hash[locale].nil?
    return cldr_hash[locale]
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

  cldr = cldr_hash[locale] = {}
  
  if xml.elements['/ldml/alias/'].nil?
    cldr[:numeric] = {}
    
  else
    alias_cldr = parse_cldr(xml.elements['/ldml/alias/'].attributes['source'],
                            cldr_hash)
    alias_cldr.each do |key, value|
      cldr[key] = value
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

    cldr_hash = {}
    Dir["#{CLDR_XML}/main/*.xml"].collect! {|file| File.basename file, ".xml"}.
                                  select {|locale| locale =~ /^..(_..)?$/}.
                                  each do |locale|
      parse_cldr(locale, cldr_hash)
      cldr = PStore.new("#{CLDR_PSTORE}/#{locale}.pstore")
      cldr.transaction do
        cldr_hash[locale].each do |key, value|
          cldr[key] = value
        end
      end
    end
  end

  desc "Processing of CLDR data"
  task :process

  unless File.directory? "#{pwd}/data/cldr"
    task :process => [:force_process] 
  end
end

