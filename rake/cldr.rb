namespace :cldr do
  desc "Force download and unzip of CLDR files"
  task :force_download do
    require 'net/http'
    require 'fileutils'
    
    FileUtils.mkdir_p [pwd, 'tmp', 'cldr-core']
    Net::HTTP.start('unicode.org') do |http|
      resp = http.get('/Public/cldr/1.6.1/core.zip')
      open("#{pwd}/tmp/cldr-core-1.6.1.zip", 'wb') do |file|
        file.write(resp.body)
      end
    end

    sh %{unzip -qo #{pwd}/tmp/cldr-core-1.6.1.zip -d #{pwd}/tmp/cldr-core}
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
    
    if File.directory? "#{pwd}/data/cldr"
      FileUtils.rm_r "#{pwd}/data/cldr"
    end
    FileUtils.mkdir_p [pwd, 'data', 'data/cldr']

    Dir["#{pwd}/tmp/cldr-core/main/*.xml"].each do |file|
      puts "Processing #{file}"
      open(file) do |file|
        xml = REXML::Document.new(file)
        
        lang = xml.elements["/ldml/identity/language"].attributes["type"]
        terr = xml.elements["/ldml/identity/territory"]
        unless terr.nil?
          terr = terr.attributes["type"]
        end
        script = xml.elements["/ldml/identity/script"]
        unless script.nil?
          script = script.attributes["type"]
        end

        if terr.nil?
          if script.nil?
            cldr = PStore.new("#{pwd}/data/cldr/#{lang}.pstore")
          else
            cldr = PStore.new("#{pwd}/data/cldr/#{lang}-#{script}.pstore")
          end
        else
          if script.nil?
            cldr = PStore.new("#{pwd}/data/cldr/#{lang}-#{terr}.pstore")
          else
            cldr = PStore.new("#{pwd}/data/cldr/#{lang}-#{script}-#{terr}.pstore")
          end
        end
        
        xml.elements.each('/*/alias') do |al|
          source = REXML::Document.new(open("#{pwd}/tmp/cldr-core/main/#{al.attributes['source']}.xml"))
          path = al.attributes['path'] || al.parent.xpath
          source.elements.each('#{path}/*') do |e|
            al.parent << e
          end
          al.parent.delete(al)
        end

        cldr.transaction do
          
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

