# Copyright Cloudinary

class Cloudinary::Migrator
  attr_reader :retrieve, :complete
  attr_accessor :terminate, :in_process
  attr_reader :db
  attr_reader :work, :results, :mutex
  attr_reader :extra_options
  
  
  @@init = false
  def self.init
    return if @@init
    @@init = true

    begin 
      require 'sqlite3'
    rescue LoadError
      raise "Please add sqlite3 to your Gemfile"    
    end
    require 'tempfile'
  end
  
  def json_decode(str)
    Cloudinary::Utils.json_decode(str)
  end
    
  def initialize(options={})
    self.class.init
    
    options[:db_file] = "tmp/migration#{$$}.db" if options[:private_database] && !options[:db_file] 
    @dbfile = options[:db_file] || "tmp/migration.db"
    FileUtils.mkdir_p(File.dirname(@dbfile))
    @db = SQLite3::Database.new @dbfile, :results_as_hash=>true
    @retrieve = options[:retrieve]
    @complete = options[:complete]
    @debug = options[:debug] || false
    @ignore_duplicates = options[:ignore_duplicates]
    @threads = [options[:threads] || 10, 100].min
    @threads = 1 if RUBY_VERSION < "1.9"
    @extra_options = {:api_key=>options[:api_key], :api_secret=>options[:api_secret]}
    @delete_after_done = options[:delete_after_done] || options[:private_database]
    @max_processing = @threads * 10
    @in_process = 0
    @work = Queue.new
    @results = Queue.new
    @mutex = Mutex.new
    @db.execute "
      create table if not exists queue (
        id integer primary key,
        internal_id integer,
        public_id text,
        url text,
        metadata text,
        result string,
        status text,
        updated_at integer
      )
    "
    @db.execute "
      create index if not exists status_idx on queue (
        status
      )
    "
    @db.execute "
      create unique index if not exists internal_id_idx on queue (
        internal_id
      )
    "
    @db.execute "
      create unique index if not exists public_id_idx on queue (
        public_id
      )
    "

    if options[:reset_queue]
      @db.execute("delete from queue")
    end
  end
    
  def register_retrieve(&block)
    @retrieve = block
  end

  def register_complete(&block)
    @complete = block
  end
  
  def process(options={})    
    raise CloudinaryException, "url not given and no retrieve callback given" if options[:url].nil? && self.retrieve.nil?
    raise CloudinaryException, "id not given and retrieve or complete callback given" if options[:id].nil? && (!self.retrieve.nil? || !self.complete.nil?)

    debug("Process: #{options.inspect}")
    start
    process_results    
    wait_for_queue
    options = options.dup
    id = options.delete(:id)
    url = options.delete(:url)
    public_id = options.delete(:public_id)
    row = {
      "internal_id"=>id, 
      "url"=>url, 
      "public_id"=>public_id, 
      "metadata"=>options.to_json,
      "status"=>"processing"      
    }    
    begin
      insert_row(row)
      add_to_work_queue(row)
    rescue SQLite3::ConstraintException
      raise if !@ignore_duplicates
    end
  end
      
  def done
    start
    process_all_pending
    @terminate = true
    1.upto(@threads){self.work << nil} # enough objects to release all waiting threads
    @started = false
    @db.close
    File.delete(@dbfile) if @delete_after_done
  end
  
  def max_given_id
    db.get_first_value("select max(internal_id) from queue").to_i
  end
  
  def close_if_needed(file)
    if file.nil?
      # Do nothing.
    elsif file.respond_to?(:close!) 
      file.close! 
    elsif file.respond_to?(:close)
      file.close
    end
  rescue
    # Ignore errors in closing files
  end  

  def temporary_file(data, filename)  
    file = RUBY_VERSION == "1.8.7" ? Tempfile.new('cloudinary') : Tempfile.new('cloudinary', :encoding => 'ascii-8bit')
    file.unlink
    file.write(data)
    file.rewind
    # Tempfile return path == nil after unlink, which break rest-client              
    class << file
      attr_accessor :original_filename
      def content_type
        "application/octet-stream"                  
      end
    end
    file.original_filename = filename
    file                  
  end

  private

  def update_all(values)
    @db.execute("update queue set #{values.keys.map{|key| "#{key}=?"}.join(",")}", *values.values)
  end
  
  def update_row(row, values)    
    values.merge!("updated_at"=>Time.now.to_i)
    query = ["update queue set #{values.keys.map{|key| "#{key}=?"}.joinlass.respond_to?(:update_all) && uploader.model.respond_to?(:_id)
      model_class.where(:_id=>uploader.model._id).update_all(column=>name)
      uploader.model.send :write_attribute, column, name
    else
      raise CloudinaryException, "Only ActiveRecord, Mongoid and Sequel are supported at the moment!"
    end
  end
end
or updating a column
  * Add support for `named` parameter in list transformation API
  * load environment when running sync_static task
  * Fix the overwritten initializer for hash (#273)
  * Force TravisCI to install bundler
  * Fix CloudinaryFile::exists? method. Solves #193 #205
  * Update Readme to point to HTTPS URLs of cloudinary.com

1.8.1 / 2017-05-16
==================

  * Fix `image_path`. Fixes #257
  * Add Auto Gravity modes tests.
  * Use correct values in Search tests

1.8.0 / 2017-05-01
==================

New functionality and features
------------------------------

  * Add Search API
  * Sync static for non image assets (#241) fixes #27

Other Changes
-------------

  * Fix Carrierwave signed URL.

1.7.0 / 2017-04-09
==================

New functionality and features
------------------------------

  * Added resource publishing API
    * `Api.publish_by_prefix`
    * `Api.publish_by_tag`
    * `Api.publish_by_ids`
  * Support remote URLs in `Uploader.upload_large` API
  * Add missing parameters to generate-archive
    * `skip_transformation_name`
    * `allow_missing`
  * Added context API methods
    * `Api.add_context`
    * `Api.remove_all_context`
  * Added `Uploader.remove_all_tags` method
  * Support URL SEO suffix for authenticated images
  * Add support of "format" parameter to responsive-breakpoints hash
  * Add notification_url to update API
  

Other Changes
-------------

  * Remove tag from test
  * Change test criteria from changing versions to bytes
  * Use `TRAVIS_JOB_ID` if available or random. Move auth test constants to spec_helper.
  * Add test for deleting public IDs which contain commas
  * Move expression and replacement to constants
  * Don't normalize negative numbers
  * Added generic aliasing to methods named with image
  * Added Private annotation to certain utility methods
  * Add `encode_context` method to `Utils`
  * Escape = and | characters in context values + test
  * Add more complex eager test cases
  * Switch alias_method_chain to alias_method to support Rails version >5.1

1.6.0 / 2017-03-08
==================

New functionality and features
------------------------------

  * Support user defined variables
  * Add `to_type` parameter to the rename method (#236)
  * Add `async` parameter to the upload method (#235)

Other Changes
-------------

  * Switch ow & oh to iw & ih on respective test case
  * test auto gravity transformation in URL build

1.5.2 / 2017-02-22
==================

  * Support URL Authorization token. 
  * Rename auth_token. 
  * Support nested keys in CLOUDINARY_URL
  * Support "authenticated" url without a signature.
  * Add OpenStruct from ruby 2.0.
  * Add specific rubyzip version for ruby 1.9

1.5.1 / 2017-02-13
==================
  * Fix Carrierwave 1.0.0 integration: broken `remote_image_url`

1.5.0 / 2017-02-07
==================

New functionality and features
------------------------------

  * Access mode API

Other Changes
-------------

  * Fix transformation related tests.
  * Fix archive test to use `include` instead of `match_array`.
  * Fix "missing folder" test
  * Add specific dependency on nokogiri
  * Update rspec version

1.4.0 / 2017-01-30
==================

  * Add Akamai token generator
tra_options.merge(:public_id=>row["public_id"])
              json_decode(row["metadata"]).each do
                |key, value|
                options[key.to_sym] = value
              end
                          
              result = Cloudinary::Uploader.upload(url || file, options.merge(:return_error=>true)) || ({:error=>{:message=>"Received nil from uploader!"}})
            elsif cw
              result ||= {"status" => "saved"}
            else
              result = {"error" => {"message" => "Empty data and url", "http_code"=>404}} 
            end
            main.results << {"id"=>row["id"], "internal_id"=>row["internal_id"], "result"=>result.to_json}
          rescue => e
            $stderr.print "Thread #{i} - Error in processing row #{row.inspect} - #{e}\n"
            debug(e.backtrace.join("\n"))
            sleep 1
          ensure
            main.mutex.synchronize{main.in_process -= 1}
            main.close_if_needed(file)
          end          
        end
      end
    end 
    
    retry_previous_queue # Retry all work from previous iteration before we start processing this one.
  end
  
  def debug(message)
    if @debug
      mutex.synchronize{
        $stderr.print "#{Time.now} Cloudinary::Migrator #{message}\n"
      }
    end
  end

  def retry_previous_queue
    last_id = 0
    begin
      prev_last_id, last_id = last_id, refill_queue(last_id)
    end while last_id > prev_last_id
    process_results    
  end
  
  def process_all_pending
    # Waiting for work to finish. While we are at it, process results.
    while self.in_process > 0      
      process_results
      sleep 0.1
    end
    # Make sure we processed all the results
    process_results
  end
  
  def add_to_work_queue(row)
    self.work << row
    mutex.synchronize{self.in_process += 1}
  end
  
  def wait_for_queue
    # Waiting f
    while self.work.length > @max_processing
      process_results    
      sleep 0.1
    end    
  end

  def self.sample        
    migrator = Cloudinary::Migrator.new(
      :retrieve=>proc{|id| Post.find(id).data}, 
      :complete=>proc{|id, result| a}
      )
    
    Post.find_each(:conditions=>["id > ?", migrator.max_given_id], :select=>"id") do
      |post|
      migrator.process(:id=>post.id, :public_id=>"post_#{post.id}")
    end
    migrator.done
  end 
    
  def self.test  
    posts = {}
    done = {}      
    migrator = Cloudinary::Migrator.new(
      :retrieve=>proc{|id| posts[id]}, 
      :complete=>proc{|id, result| $stderr.print "done #{id} #{result}\n"; done[id] = result}
      )
    start = migrator.max_given_id + 1
    (start..1000).each{|i| posts[i] = "hello#{i}"}
    
    posts.each do
      |id, data|
      migrator.process(:id=>id, :public_id=>"post_#{id}")
    end
    migrator.done
    pp [done.length, start]
  end        
end
