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

  
  if File.file?("#{pwd}/tmp/cldr-core-1.6.1.zip")
    task :download => [:force_download]
  end

  desc "Process CLDR"
  task :process => [:download] do
    # TODO: Implement
  end
end

